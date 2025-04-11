resource "azurerm_network_interface" "vm-nic" {
  name                                = "${local.name}-nic01"
  location                            = var.location
  resource_group_name                 = var.resource_group_name

  ip_configuration{
      name                            = "ipconfig1"
      subnet_id                       = data.azurerm_subnet.subnet.id
      private_ip_address_allocation   = var.private_ip_address != "" ? "Static" : "Dynamic"
      private_ip_address              = try(var.private_ip_address, null)
    }

  tags                                = local.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                                = local.name
  admin_username                      = var.admin_username
  admin_password                      = var.admin_password
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  network_interface_ids               = [ azurerm_network_interface.vm-nic.id ]
  license_type                        = var.windows_license
  secure_boot_enabled                 = var.secure_boot_enabled
  provision_vm_agent                  = var.provision_vm_agent
  timezone                            = var.timezone
  size                                = var.size
  vtpm_enabled                        = var.vtpm_enabled
  zone                                = var.availability_zone
  
  boot_diagnostics {
  }
  
  source_image_reference {
    publisher                         = var.publisher
    offer                             = var.offer
    sku                               = var.sku
    version                           = var.image_version
  }

  os_disk {
    name                              = "${local.name}-osdisk"
    caching                           = var.os_disk_caching
    storage_account_type              = var.os_disk_storage_account_type
  }
  
  tags                                = local.tags
}

resource "azurerm_managed_disk" "vm-datadisk" {
  for_each                            = var.data_disks != null ? var.data_disks : {}

  location                            = var.location
  resource_group_name                 = var.resource_group_name
  zone                                = var.availability_zone

  name                                = "${local.name}-datadisk${format("%02s", each.key)}"
  storage_account_type                = try(each.value.storage_account_type, null) == null ? "Premium_LRS" : each.value.storage_account_type
  create_option                       = try(each.value.create_option, null) == null ? "Empty" : each.value.create_option
  disk_size_gb                        = try(each.value.disk_size_gb, null) == null ? "16" : each.value.disk_size_gb

  tags                                = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm-datadisk-attachment" {
  for_each                            = var.data_disks != null ? var.data_disks : {}

  managed_disk_id                     = azurerm_managed_disk.vm-datadisk[each.key].id
  virtual_machine_id                  = azurerm_windows_virtual_machine.vm.id
  lun                                 = 0 + each.key
  caching                             = try(each.value.caching, null) == null ? "None" : each.value.caching
}

resource "azurerm_backup_protected_vm" "vm-protect" {
  count                               = var.deploy_backup_rsv ? 1 : 0

  resource_group_name                 = var.rg_backup_name
  recovery_vault_name                 = var.rsv_name
  source_vm_id                        = azurerm_windows_virtual_machine.vm.id
  backup_policy_id                    = var.rsv_policy_id
}

// https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
resource "azurerm_virtual_machine_extension" "vmextension" {
  count = var.post_install_uris != "" ? 1 : 0
  name                                   =  "post_install"
  virtual_machine_id                     =  azurerm_windows_virtual_machine.vm.id
  publisher                              =  "Microsoft.Compute"
  type                                   =  "CustomScriptExtension"
  type_handler_version                   =  "1.9"
  auto_upgrade_minor_version             =  "true"

  protected_settings                     =  <<PROTECTED_SETTINGS
    {
       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file post_install.ps1 -EnableCredSSP -DisableBasicAuth"
    }
  PROTECTED_SETTINGS

  settings                               =  <<SETTINGS
    {
      "fileUris": [
        "${var.post_install_uris}"
        ]
    }
  SETTINGS
}

// Shutdown the VM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vmshutdown" {
  count = var.vm_shutdown != "" ? 1 : 0

  daily_recurrence_time                  =  var.vm_shutdown
  location                               =  var.location
  timezone                               =  var.timezone
  virtual_machine_id                     =  azurerm_windows_virtual_machine.vm.id
  notification_settings {
    enabled                              =  false
  }
  depends_on                             =  [
    azurerm_windows_virtual_machine.vm,
  ]
}