variable "prefix" {
  description = "Prefix used to name every Azure resource"
  type        = string
  default     = "cicd-demo"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "koreacentral"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin user created on the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that will be installed on the VM"
  type        = string
  default     = "~/.ssh/azure_vm_key.pub"
}
