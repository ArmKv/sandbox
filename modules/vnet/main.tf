resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  edge_zone           = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  tags                = var.tags

  lifecycle {
    # precondition protects the module's final assumptions right before Terraform acts.
    precondition {
      condition     = length(var.address_space) > 0
      error_message = "The virtual network module requires at least one address space."
    }

    precondition {
      condition     = trimspace(var.name) != ""
      error_message = "The virtual network name must not be empty after applying naming logic."
    }

    # postcondition verifies the final resource state after Azure returns the created object.
    postcondition {
      condition     = self.location == var.location
      error_message = "The created virtual network location does not match the requested location."
    }
  }
}