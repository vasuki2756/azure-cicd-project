output "public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "app_url" {
  description = "URL of the deployed web application"
  value       = "http://${azurerm_public_ip.pip.ip_address}"
}

output "ssh_command" {
  description = "Command to SSH into the VM"
  value       = "ssh -i ~/.ssh/azure_vm_key ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}
