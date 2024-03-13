This repository contains a Terraform configuration for deploying a single-tenant Microsoft Sentinel environment in Azure, specifically in the France Central region. The deployment automates the provisioning of critical security components, including an Azure Sentinel workspace, a storage account, an Event Hub, and an Azure Data Explorer cluster, following best practices for security and scalability.

The resources are defined in a azure_sentinel_deployment.tf file, which is designed to be customizable through the use of variable definitions. The repository also includes a deploy_resources.ps1 PowerShell script, which facilitates the setup of the Azure environment, deployment, and management of resources. It includes features such as Azure login, subscription listing and selection, resource deployment through Terraform, and an optional cleanup process to remove resources if required.

Lastly, a terraform.tfvars file is included to provide default values for the deployment. Users are encouraged to tailor this file to their specific needs by modifying the resource_prefix to ensure resource name uniqueness within Azure.

This setup is intended for use by Azure administrators or DevOps professionals who need to quickly and reliably roll out an instance of Microsoft Sentinel, ensuring a robust security posture for their cloud environments
