# Scenario
Creating an ILB ASE with App Service plan in a new Virtual Network in a new Subnet
The complete goal is to create an App Gateway + WAF and put that in front of this ASE 
Also some of the webapps in the ASE expose an API which needs to be integrated with an API Management Gateway

# Tools
using Terraform 0.12 and above for this directory

# Issues
* Terraform does not currently supports ASE as a native resource due to some Azure API issue. 
* Terraform provides a way to deploy ARM templates using ARM Template Deployment resource - we are using this to create an ASE
* Terraform currently is not able to fetch the refresh token and refresh the access token and thus times out in case of a long run (>45 mins normally) - although they are working on fixing this. 
