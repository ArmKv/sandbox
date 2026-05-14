output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group."
  value       = module.rg.id
}

output "resource_group_location" {
  description = "The Azure region of the resource group."
  value       = module.rg.location
}

output "resource_group_tags" {
  description = "The tags assigned to the resource group."
  value       = module.rg.tags
}

output "virtual_network_name" {
  description = "The name of the virtual network."
  value       = module.vnet.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = module.vnet.id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by subnet logical name."
  value       = module.subnet.ids
}