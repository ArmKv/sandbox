output "ids" {
  description = "Subnet IDs keyed by subnet map key."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

output "names" {
  description = "Subnet names keyed by subnet map key."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.name }
}