# terraform-azure
Terraform on Azure Examples

# Setup
Create a Service Principal for authorizing Terraform to create resources in your subscription. Limit the scope of the SP to your subscription
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID" 
```
More details [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

## Environment Variables 

Terraform requires certain Environment variables to be set in order to work properly
```
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
export ARM_CLIENT_ID=$APP_ID
export ARM_CLIENT_SECRET=$PASSWORD
export ARM_TENANT_ID=$TENANT_ID
```

## Verify Setup
Go to testinstall directory and run the following commands to test
```
terraform init
terraform plan
terraform apply
terraform destroy
```
