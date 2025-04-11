resource_group_name                 = "XXX-corp-rg-servers-test"
# data_disks = {
# 1 = {
#     storage_account_type            = "Premium_LRS"
#     create_option                   = "Empty"
#     disk_size_gb                    = "16"
#     caching                         = "None"
# },
# 2 = {
#     storage_account_type            = "Premium_LRS"
#     create_option                   = "Empty"
#     disk_size_gb                    = "16"
#     caching                         = "None"
# }
# }
vnet_name                           = "XXX-corp-vn-dta"
vnet_resource_group_name            = "XXX-corp-rg-network" #!!!!
subnet_name                         = "XXX-corp-sn-dta-test"
private_ip_address                  = "10.23.2.4"
#availability_zone                   = 1
secure_boot_enabled                 = true
vtpm_enabled                        = true
size                                = "Standard_D2as_v5"
# timezone                          = var.timezone
admin_password                      = "<PASSWORD>"
windows_license                     = "None"
tags                                = {
                                        "subscription"                    = "corp"
                                        "environment"                     = "test"
                                        "server role"                     = "applicationserver"
                                        "application"                     = "applicationX"
                                        "managed by"                      = "ictivity"
                                        "backup app"                      = "azure backup"
                                        "backup policy"                   = "corp bronze"
                                        "customer"                        = "CustomerX"
                                    }
root_id                             = "XXX"
name_suffix                         = "app03" # Zorgt voor een VM met naam: 'XXX-app03'
location                            = "westeurope"
#post_install_uris                   =  "https://raw.githubusercontent.com/ibeerens/Terraform/main/Scripts/post_install.ps1"
#vm_shutdown                         =  "2100"