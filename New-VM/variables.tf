#   ____                       _       _     _     ___     _   _       _ _         
#  / ___|___  _ __  _   _ _ __(_) __ _| |__ | |_  |_ _|___| |_(_)_   _(_) |_ _   _ 
# | |   / _ \| '_ \| | | | '__| |/ _` | '_ \| __|  | |/ __| __| \ \ / / | __| | | |
# | |__| (_) | |_) | |_| | |  | | (_| | | | | |_   | | (__| |_| |\ V /| | |_| |_| |
#  \____\___/| .__/ \__, |_|  |_|\__, |_| |_|\__| |___\___|\__|_| \_/ |_|\__|\__, |
#            |_|    |___/        |___/                                       |___/ 

variable "root_id" {
  type                                = string
  description                         = "Prefix for all resources. This is an Ictivity tenant ID or a Customer prefix"
}

variable "name_suffix" {
  type                                = string
  description                         = "Name part of the vm"
}

variable "location" {
  type                                = string
  description                         = "Sets the location for resources to be created in."
}

variable "tags" {
  type                                = map(string)
  description                         = "Map of tags"
}

variable "resource_group_name" {
  type                                = string
  description                         = "Resource Group for the VM"
}

variable "deploy" {
  type                                = bool
  description                         = "Deploy this resources"
  default                             = true
}

variable "admin_username" {
  type                                = string
  description                         = "Local administrator username"
  default                             = "azlocadmin"
}

variable "admin_password" {
  type                                = string
  description                         = "Local administrator password"
}

variable "windows_license" {
  type                                = string
  description                         = "Use Hybrid Benefit for all Windows VMs if set to \"None\". Uses Azure for licensing when set to \"Windows_Server\""

  validation {
    condition                         = can(regex("^(None|Windows_Server)$", var.windows_license))
    error_message                     = "Invalid input, options: \"None\", \"Windows_Server\"."
  }
}

variable "deploy_backup_rsv" {
  type                                = bool
  description                         = "Deploy a Recovery Services Vault for back-ups"
  default                             = false
}

variable "rg_backup_name" {
  type                                = string
  description                         = "Resource Group name of the Azure Backup Recovery Vault"
  default                             = null
}

variable "rsv_name" {
  type                                = string
  description                         = "Name of the Azure Backup Recovery Vault"
  default                             = null
}

variable "rsv_policy_id" {
  type                                = string
  description                         = "Name of the Azure Backup Recovery Vault policy for back-ups"
  default                             = null  
}

variable "availability_zone"{
  type                                = number
  description                         = "Number of the Availability Zone, must be in [1,2,3]."
  default                             = null

  validation {
    condition                         = var.availability_zone == null || (coalesce(var.availability_zone, 0) >= 1 && coalesce(var.availability_zone, 4) <= 3)
    error_message                     = "Accepted values: null or 1-3."
  }  
}

variable "size" {
  type                                = string
  description                         = "Size of the VM. (default = Standard_D2as_v5)"
  default                             = "Standard_D2as_v5"
  nullable                            = false
}

variable "timezone" {
  type                                = string
  description                         = "Time zone (default = W. Europe Standard Time)"
  default                             = "W. Europe Standard Time"
}

variable "secure_boot_enabled" {
  type                                = bool
  description                         = "Enable Secure Boot (default = true)"
  default                             = true
}

variable "vtpm_enabled" {
  type                                = bool
  description                         = "Enable vPTM (default = true)"
  default                             = true
}

variable "provision_vm_agent" {
  type                                = bool
  description                         = "Provision Azure VM Agent (default = true)"
  default                             = true
}

variable "publisher" { 
  type                                = string
  description                         = "Image Publisher (default = MicrosoftWindowsServer)"
  default                             = "MicrosoftWindowsServer"
}

variable "offer" {
  type                                = string
  description                         = "Image Offer (default = WindowsServer)"
  default                             = "WindowsServer"
}

variable "sku" {
  type                                = string
  description                         = "Image Sku (default = 2022-datacenter-azure-edition)"
  default                             = "2022-datacenter-azure-edition"
}

variable "image_version" { 
  type                                = string
  description                         = "Image Version (default = latest)"
  default                             = "latest"
}

variable "os_disk_caching" {
  type                                = string
  description                         = "OS Disk Caching (default = ReadWrite)"
  default                             = "ReadWrite"

  validation {
    condition                         = can(regex("^(None|ReadOnly|ReadWrite)$", var.os_disk_caching))
    error_message                     = "Invalid input, options: \"None\", \"ReadOnly\", \"ReadWrite\"."
  }
}

variable "os_disk_storage_account_type" {
  type                                = string
  description                         = "OS Disk Storage Account Type (default = Premium_LRS)"
  default                             = "Premium_LRS"
}

variable "data_disks" {
  type                                = map(object({
    storage_account_type              = string
    create_option                     = string
    disk_size_gb                      = string
    caching                           = string
  }))
  description                         = "Data disks to create when creating the VM"
  default = {}
}

variable "vnet_name" {
  type                                   =  string
  description                            =  "Existing VNET name" 
}

variable "vnet_resource_group_name" {
  type                                = string
  description                         = "Resource Group for the VNET"
}

variable "subnet_name" {
  type = string
}

variable "private_ip_address" {
  type = string
}

variable "post_install_uris" {
  type                                   =  string
  description                            =  "URI's for the post installation script"
  default = ""
}

variable "vm_shutdown" {
  type                                   =  string
  description                            =  "VM shutdown time"
  default = ""
}
