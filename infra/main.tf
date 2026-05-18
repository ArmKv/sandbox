locals {
  resource_group_name  = "${var.project_name}-${var.environment}-rg"
  # try handles a missing attribute access, and coalesce replaces a null result with the default name.
  virtual_network_name = coalesce(try(var.vnet.name, null), "${var.project_name}-${var.environment}-vnet")

  # lookup reads a map key and falls back to var.environment when the tag is missing.
  environment_tag      = lookup(var.tags, "environment", var.environment)

  # toset converts an input list into a set so duplicate service endpoints are removed before module use.
  normalized_subnets = {
    for subnet_name, subnet in var.subnets : subnet_name => merge(
      subnet,
      {
        service_endpoints = try(subnet.service_endpoints, null) == null ? null : toset(subnet.service_endpoints)
      }
    )
  }
}

module "rg" {
  source = "../modules/rg"

  name     = local.resource_group_name
  location = var.location
  tags     = merge(var.tags, { "environment" = local.environment_tag })
}

module "vnet" {
  source = "../modules/vnet"

  name                    = local.virtual_network_name
  resource_group_name     = module.rg.name
  location                = var.location
  address_space           = var.vnet.address_space
  # Optional attributes may evaluate to null rather than error, so use a real fallback list when needed.
  dns_servers             = try(var.vnet.dns_servers, [])
  edge_zone               = try(var.vnet.edge_zone, null)
  flow_timeout_in_minutes = try(var.vnet.flow_timeout_in_minutes, null)
  tags                    = merge(var.tags, try(var.vnet.tags, {}))
}

module "subnet" {
  source = "../modules/subnet"

  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  subnets              = local.normalized_subnets
}