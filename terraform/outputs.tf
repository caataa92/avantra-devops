output "vm_external_ip" { value = module.vm.instance_ip }
output "vm_internal_ip" { value = module.vm.instance_internal_ip }
output "vm_name" { value = module.vm.instance_name }
output "vm_ssh_user" { value = var.ssh_user }