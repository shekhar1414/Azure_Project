resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.prefix}-NIC0${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
  name                          = "ipconfig1"
  subnet_id                     = var.subnet_id
  private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-VM0${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2pts_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  tags                = var.tags

  network_interface_ids = [
    element(azurerm_network_interface.nic.*.id, count.index)
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOT
#!/bin/bash
set -x

# Wait for the data disk to be attached
sleep 30

# Format and mount the data disk
disk=/dev/sdc
parted -s $disk mklabel gpt mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sdc1
mount /dev/sdc1 /datadrive

# Add to fstab for auto-mounting on boot
echo "/dev/sdc1 /datadrive ext4 defaults,nofail 0 2" >> /etc/fstab
  EOT
  )
}

resource "azurerm_managed_disk" "datadisk" {
  count                = var.vm_count
  name                 = "${var.prefix}-datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk_attachment" {
  count                = var.vm_count
  managed_disk_id    = azurerm_managed_disk.datadisk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[count.index].id
  lun                  = "10"
  caching              = "ReadWrite"
}

output "vm_private_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "vm_ids" {
  value = azurerm_linux_virtual_machine.vm[*].id
}


# Associate NICs with Load Balancer Backend Pool
resource "azurerm_network_interface_nat_rule_association" "nic_nat_rule_assoc" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "ipconfig1"
  nat_rule_id             = element(var.lb_nat_rule_ids, count.index)
}
