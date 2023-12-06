# myterraproject
This is terraform project for already created vpc, subnets and so on.
## Terraform

This is sample terraform HCL for creating RDS and EC2 instance for already created VPCs, subnets and so on.

### prerequisites
1. [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. [AWS Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)



### Steps
1. Insert your desired values at terraform.tfvars and secrets.tfvars file.
2. Clone the repo
```bash
  git clone https://github.com/sabin2018/myterraproject.git
```
3. Apply the terraform
```bash
cd terraform/
chmod +x apply.sh
./apply.sh
```
4. Destroy the terraform
```bash
cd terraform/
chmod +x destroy.sh
./destroy.sh
```
Note: 
1. Insert your desired values at terraform.tfvars and secrets.tfvars file.
2.  Uncomment the .tfvars files in .gitignore file during the push if you wish to kept your variable unshare. 

