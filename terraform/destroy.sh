#!/bin/bash
terraform destroy -var-file=terraform.tfvars -var-file=secrets.tfvars

# Check the result of Terraform destroy
if [ $? -eq 0 ]; then
    echo "Terraform destroy completed successfully."
else
    echo "Terraform destroy encountered an error. Please check the logs for details."
fi
