# Automated Deployment of a Web Application using CI/CD, Terraform, Azure and Jenkins

GitHub -> Jenkins -> Azure VM, with the Azure infrastructure created by Terraform.

## Structure

```
.
├── app/                 Node.js (Express) web app
├── terraform/           Azure infrastructure as code
│   ├── main.tf          Resource group, VNet, subnet, public IP, NSG, NIC, VM
│   ├── variables.tf
│   ├── outputs.tf
│   └── cloud-init.yaml  Installs Node.js, PM2 and Nginx on first boot
└── Jenkinsfile          Checkout -> Build -> Deploy -> Verify
```

## Provision the infrastructure

```powershell
az login
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)
cd terraform
terraform init
terraform plan
terraform apply
```

Note the `public_ip` output. Wait 3-5 minutes for cloud-init to finish on the VM.

## Run Jenkins locally

```powershell
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

Install the SSH Agent plugin, add an "SSH Username with private key" credential with ID `azure-vm-key`
(username `azureuser`), set `VM_HOST` in the `Jenkinsfile`, then create a Pipeline job from SCM.

## Clean up

```powershell
cd terraform
terraform destroy
```
