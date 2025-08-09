# SSH Keys for Terraform Technical Test

This directory contains the SSH key pair used for EC2 instance access in the Terraform technical test project.

## Files

- `terraform-key` - Private SSH key (excluded from git)
- `terraform-key.pub` - Public SSH key (committed to repo)

## Key Information

- **Key Type**: RSA 2048-bit
- **Key Name**: terraform-key
- **Purpose**: EC2 instance SSH access
- **Comment**: terraform-technical-test

## Usage

### Connecting to EC2 Instances

From the project root directory:

```bash
# Connect to public EC2 instance
ssh -i keys/terraform-key ec2-user@<public-ip>

# Connect to private EC2 instance (from public instance)
ssh -i terraform-key ec2-user@<private-ip>
```

### Key Permissions

Ensure proper permissions on the private key:

```bash
chmod 600 keys/terraform-key
```

## Security Notes

- The private key (`terraform-key`) is excluded from version control via `.gitignore`
- The public key (`terraform-key.pub`) is safely committed to the repository
- Never share the private key or commit it to version control
- Use this key only for the test environment

## Key Generation Command

This key pair was generated with:

```bash
ssh-keygen -t rsa -b 2048 -f ./keys/terraform-key -N "" -C "terraform-technical-test"
```

## Terraform Integration

The public key is automatically imported by Terraform through the EC2 module:
- Module path: `shared-modules/ec2/main.tf`
- Resource: `aws_key_pair.main`
- Public key source: `file("${path.root}/../../keys/terraform-key.pub")`