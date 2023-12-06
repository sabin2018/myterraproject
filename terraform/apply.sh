#!/bin/bash

# Check if AWS CLI is installed
if command -v aws &> /dev/null
then
    echo "AWS CLI is installed"
else
    echo "AWS CLI is not installed"

    # Ask if the user wants to install AWS CLI
    read -p "Do you want to install AWS CLI? (Type 'yes' or 'no'): " aws_install

    if [ "$aws_install" == "no" ]; then
        echo "Process terminated."
        exit 1
    elif [ "$aws_install" == "yes" ]; then
        # Install AWS CLI
        echo "Installing AWS CLI..."
        # Example: brew install awscli
        brew install awscli
    else
        echo "Invalid input. Process terminated."
        exit 1
    fi
fi

# Check if AWS is configured
if aws configure list
then
    echo "AWS is configured"
else
    # Ask if the user wants to configure AWS
    read -p "AWS is not configured. Do you want to configure AWS? (Type 'yes' or 'no'): " aws_configure

    if [ "$aws_configure" == "no" ]; then
        echo "Process terminated."
        exit 1
    elif [ "$aws_configure" == "yes" ]; then
        # Configure AWS
        aws configure
    else
        echo "Invalid input. Process terminated."
        exit 1
    fi
fi

# Check if Terraform is installed
if command -v terraform &> /dev/null
then
    echo "Terraform is already installed"
else
    echo "Terraform is not installed"

    # Ask if the user wants to install Terraform
    read -p "Do you want to install Terraform? (Type 'yes' or 'no'): " terraform_install

    if [ "$terraform_install" == "no" ]; then
        echo "Process terminated."
        exit 1
    elif [ "$terraform_install" == "yes" ]; then
        # Install Terraform
        echo "Installing Terraform..."
        # Brew install terraform
        brew install terraform
    else
        echo "Invalid input. Process terminated."
        exit 1
    fi
fi

# After successful Terraform installation
echo "Terraform is successfully installed."

# Ask if the user wants to proceed further with Terraform commands
read -p "Do you want to proceed further with Terraform? (Type 'yes' or 'no'): " terraform_proceed

if [ "$terraform_proceed" == "no" ]; then
    echo "Process terminated."
    exit 1
elif [ "$terraform_proceed" == "yes" ]; then
    # Run Terraform commands
    terraform plan
    terraform init
    terraform apply -var-file=terraform.tfvars -var-file=secrets.tfvars
else
    echo "Invalid input. Process terminated."
    exit 1
fi


