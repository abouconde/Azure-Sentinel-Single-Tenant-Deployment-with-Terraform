# PowerShell script to handle Azure login, list subscriptions, set the context, and deploy Terraform configuration

# Ask the user to login to Azure
Write-Host "Logging into Azure..."
az login

# List all subscriptions
Write-Host "Fetching all Azure subscriptions..."
$subscriptions = az account list | ConvertFrom-Json
foreach ($sub in $subscriptions) {
    Write-Host "Subscription Name: $($sub.name)"
    Write-Host "Subscription ID: $($sub.id)`n"
}

# Prompt the user to choose a subscription
$subscriptionId = Read-Host "Please enter the Subscription ID you want to use for deployment"
az account set --subscription $subscriptionId

# Verify and install required modules
if (-not(Get-Module -ListAvailable -Name Az.Accounts)) {
    Install-Module -Name Az.Accounts -Scope CurrentUser -Repository PSGallery -Force
}
Import-Module Az.Accounts -Force

if (-not(Get-Module -ListAvailable -Name Az.Resources)) {
    Install-Module -Name Az.Resources -Scope CurrentUser -Repository PSGallery -Force
}
Import-Module Az.Resources -Force

# Initialize and apply Terraform configuration
terraform init
terraform apply -auto-approve

# Optional cleanup: Ask the user if they want to delete the deployed resources
$delete = Read-Host "Do you want to delete the deployed resources? (Y/N)"
if ($delete -eq "Y" -or $delete -eq "y") {
    terraform destroy -auto-approve
}
