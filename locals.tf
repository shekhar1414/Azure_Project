locals {
  rg_name     = "${var.prefix}-RG01"
  vnet_name   = "${var.prefix}-VNET01"
  subnet_name = "${var.prefix}-SUBNET01"
  nsg_name    = "${var.prefix}-NSG01"
  lb_name     = "${var.prefix}-LB01"
  pip_name    = "${var.prefix}-PIP01"
}
