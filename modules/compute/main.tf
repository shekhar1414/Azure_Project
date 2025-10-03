resource "azurerm_network_interface" "nic" {
  count               = 3
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
  count               = 3
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
}

output "vm_private_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "vm_ids" {
  value = azurerm_linux_virtual_machine.vm[*].id
}


# Associate NICs with Load Balancer Backend Pool
resource "azurerm_network_interface_nat_rule_association" "nic_nat_rule_assoc" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "ipconfig1"
  nat_rule_id             = element(var.lb_nat_rule_ids, count.index)
}
