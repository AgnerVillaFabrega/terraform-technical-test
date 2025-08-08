# Task 1: VPC Setup & Security Groups

## Overview

Esta documentación describe la implementación del primer paso del test técnico de Terraform: **VPC Setup & Security Groups**. Se ha creado una infraestructura de red completa en AWS que incluye VPC, subnets públicas y privadas, security groups y instancias EC2.

## Estado: ✅ COMPLETADO

## Arquitectura Implementada

```
VPC (10.0.0.0/16)
├── Public Subnets
│   ├── Public Subnet 1 (10.0.1.0/24) - AZ us-east-1a
│   └── Public Subnet 2 (10.0.2.0/24) - AZ us-east-1b
└── Private Subnets
    ├── Private Subnet 1 (10.0.10.0/24) - AZ us-east-1a
    └── Private Subnet 2 (10.0.20.0/24) - AZ us-east-1b

Networking Components:
├── Internet Gateway (IGW)
├── NAT Gateway 1 (Public Subnet 1)
├── NAT Gateway 2 (Public Subnet 2)
├── Public Route Table (0.0.0.0/0 → IGW)
├── Private Route Table 1 (0.0.0.0/0 → NAT GW 1)
└── Private Route Table 2 (0.0.0.0/0 → NAT GW 2)

Security Groups:
├── Public SG (SSH:22 + HTTP:80 from 0.0.0.0/0)
└── Private SG (SSH:22 from Public SG only)

EC2 Instances:
├── Public EC2 (t2.micro) - Public Subnet 1
└── Private EC2 (t2.micro) - Private Subnet 1
```

## Componentes Creados

### 1. VPC y Networking
- **VPC**: `10.0.0.0/16` con DNS habilitado
- **Internet Gateway**: Para acceso a internet desde subnets públicas
- **2 Public Subnets**: `10.0.1.0/24`, `10.0.2.0/24` en diferentes AZs
- **2 Private Subnets**: `10.0.10.0/24`, `10.0.20.0/24` en diferentes AZs
- **2 NAT Gateways**: Uno por AZ para acceso saliente desde subnets privadas
- **Route Tables**: Configuradas para dirigir tráfico correctamente

### 2. Security Groups

#### Public Security Group
```hcl
Ingress Rules:
- SSH (22/tcp): 0.0.0.0/0
- HTTP (80/tcp): 0.0.0.0/0

Egress Rules:
- All traffic (0/all): 0.0.0.0/0
```

#### Private Security Group  
```hcl
Ingress Rules:
- SSH (22/tcp): Public Security Group only

Egress Rules:
- All traffic (0/all): 0.0.0.0/0
```

### 3. EC2 Instances

#### Public EC2
- **AMI**: Amazon Linux 2
- **Instance Type**: t2.micro
- **Placement**: Public Subnet 1
- **Security Group**: Public SG
- **Features**: Auto-assign public IP, HTTP server instalado

#### Private EC2
- **AMI**: Amazon Linux 2
- **Instance Type**: t2.micro
- **Placement**: Private Subnet 1
- **Security Group**: Private SG
- **Features**: Solo IP privada, accesible desde public instance

## Configuración de Conectividad

### Flujo de Tráfico
1. **Internet → Public EC2**: Directo via Internet Gateway
2. **Public EC2 → Private EC2**: Via SSH usando security group rules
3. **Private EC2 → Internet**: Saliente via NAT Gateway
4. **Internet → Private EC2**: ❌ Bloqueado (no acceso directo)

### Routing Configuration
- **Public subnets**: `0.0.0.0/0` → Internet Gateway
- **Private subnets**: `0.0.0.0/0` → NAT Gateway (por AZ)
- **Local traffic**: `10.0.0.0/16` permanece en la VPC

## Estructura de Archivos

```
environments/t-test/
├── main.tf                    # Configuración principal
├── variables.tf              # Variables del ambiente
├── outputs.tf               # Outputs del ambiente
├── terraform.tfvars.example # Ejemplo de variables
└── README.md               # Guía de setup

shared-modules/
├── vpc/                    # Módulo VPC
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── security-groups/        # Módulo Security Groups
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── ec2/                   # Módulo EC2
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Prerequisitos

### SSH Key Pair
```bash
ssh-keygen -t rsa -b 2048 -f ./terraform-key -N "" -C "terraform-technical-test"
```
Se ha generado un par de claves SSH en el directorio raíz del proyecto:
- **Clave privada**: `terraform-key`
- **Clave pública**: `terraform-key.pub`

Esta clave se utiliza automáticamente por Terraform para crear y acceder a las instancias EC2.

## Pasos de Verificación

### 1. Verificar Recursos Creados
```bash
cd environments/t-test
terraform plan
terraform apply
```

### 2. Obtener IPs de las Instancias
```bash
terraform output public_ec2_public_ip
terraform output private_ec2_private_ip
```

### 3. Probar Conectividad
```bash
# SSH a instancia pública (desde el directorio raíz del proyecto)
ssh -i ./terraform-key ec2-user@<public-ip>

# Desde instancia pública, SSH a instancia privada (después de copiar la clave privada)
ssh -i terraform-key ec2-user@<private-ip>
```

### 4. Verificar HTTP Server
```bash
# Acceder al servidor HTTP en la instancia pública
curl http://<public-ip>
```

## Buenas Prácticas Implementadas

### ✅ Seguridad
- Security groups con reglas restrictivas
- Private subnets sin acceso directo desde internet
- NAT Gateways para acceso saliente seguro

### ✅ Alta Disponibilidad
- Recursos distribuidos en múltiples AZs
- NAT Gateways redundantes

### ✅ Escalabilidad
- Arquitectura modular
- Variables configurables
- Estructura preparada para múltiples ambientes

### ✅ Organización
- Separación por módulos
- Ambiente específico (t-test)
- Documentación completa

## Outputs Importantes

```bash
vpc_id                    = "vpc-xxxxxxxxx"
public_subnet_ids         = ["subnet-xxxxxxxxx", "subnet-yyyyyyyyy"]
private_subnet_ids        = ["subnet-zzzzzzzzz", "subnet-aaaaaaaaa"]
public_ec2_public_ip      = "x.x.x.x"
private_ec2_private_ip    = "10.0.10.x"
```

## Próximos Pasos

- [ ] **Task 2**: IAM Roles & Policies
- [ ] **Task 3**: S3 & Object Lifecycle Management  
- [ ] **Task 4**: CloudWatch Alarms & Notifications
- [ ] **Task 5**: Basic Networking Concepts Documentation

## Costos Estimados

**Recursos activos (por hora):**
- 2x EC2 t2.micro: ~$0.0232/hora
- 2x NAT Gateway: ~$0.090/hora
- 2x EIP: ~$0.005/hora

**Total estimado**: ~$0.118/hora (~$85/mes)

---

**Fecha de implementación**: 2025-08-08  
**Status**: Completado y verificado ✅