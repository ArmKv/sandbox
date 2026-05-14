resource "azurerm_subnet" "this" {
  for_each = var.subnets

  # If subnet.name is omitted, fall back to the map key such as web or app.
  name                 = coalesce(try(each.value.name, null), each.key)
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  default_outbound_access_enabled         = try(each.value.default_outbound_access_enabled, null)
  private_endpoint_network_policies       = try(each.value.private_endpoint_network_policies, null)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)
  service_endpoints                       = try(each.value.service_endpoints, null)
  service_endpoint_policy_ids             = try(each.value.service_endpoint_policy_ids, null)

  dynamic "delegation" {
    # Optional lists can be null, so convert null to [] before using for_each.
    for_each = coalesce(try(each.value.delegation, null), [])

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = coalesce(try(delegation.value.service_delegation.actions, null), [])
      }
    }
  }

  lifecycle {
    # precondition is useful here because it validates the final per-subnet values used by the resource.
    precondition {
      condition     = length(each.value.address_prefixes) > 0
      error_message = "Each subnet must define at least one address prefix."
    }

    precondition {
      condition     = trimspace(coalesce(try(each.value.name, null), each.key)) != ""
      error_message = "Each subnet must resolve to a non-empty name, either from subnet.name or the subnet map key."
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet_name, subnet in var.subnets : subnet_name => subnet
    if try(subnet.network_security_group_id, null) != null
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for subnet_name, subnet in var.subnets : subnet_name => subnet
    if try(subnet.route_table_id, null) != null
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = {
    for subnet_name, subnet in var.subnets : subnet_name => subnet
    if try(subnet.nat_gateway_id, null) != null
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = each.value.nat_gateway_id
}