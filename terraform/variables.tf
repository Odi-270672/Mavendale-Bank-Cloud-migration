variable "web_vm_ssh_public_key" {
  description = "SSH public key used to authenticate to the Mavendale Bank Web Tier VM"
  type        = string
  sensitive   = true
}
