output "vm_private_ips" {
  value = module.compute.vm_private_ips
}

output "lb_public_ip" {
  value = module.networking.lb_public_ip
}
