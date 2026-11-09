variable "web_vm_ssh_public_key" {
  description = "SSH public key used to authenticate to the Mavendale Bank Web Tier VM"
  type        = string
  sensitive   = true
}


variable "app_vm_ssh_public_key" {
  description = "SSH public key used to authenticate to the Mavendale Bank App Tier VM"
  type        = string
  sensitive   = true
}


variable "sql_admin_password" {
  description = "Password for the SQL Server administrator"
  type        = string
  sensitive   = true
}