variable "prefix" {
  description = "Prefix used to name every Azure resource"
  type        = string
  default     = "cicd-demo"
}

variable "location" {
  description = "Azure region. Azure for Students only allows some regions; try centralindia, southindia or eastasia if one fails."
  type        = string
  default     = "centralindia"
}

variable "vm_size" {
  description = "VM size. If Standard_B1s is unavailable, try Standard_B2s or Standard_B2ats_v2."
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
