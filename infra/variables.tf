variable "project_name" {
  type        = string
  description = "Base project name used in resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name such as dev or test."
}

variable "location" {
  type        = string
  description = "Azure region for the resources."
}

variable "tags" {
  type        = map(string)
  description = "Tags assigned to the resources."
  default     = {}
}

variable "vnet" {
  description = "Virtual network settings for the environment."

  type = object({
    name                    = optional(string)
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))
  })

  # can is useful in validation because it returns true or false instead of a fallback value.
  validation {
    condition = length(var.vnet.address_space) > 0 && alltrue([
      for cidr in var.vnet.address_space : can(cidrnetmask(cidr))
    ])
    error_message = "vnet.address_space must contain one or more valid CIDR ranges, such as 10.10.0.0/16."
  }
}

variable "subnets" {
  description = "Subnet definitions keyed by logical subnet name."

  type = map(object({
    name                                   = optional(string)
    address_prefixes                       = list(string)
    default_outbound_access_enabled        = optional(bool)
    private_endpoint_network_policies      = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                      = optional(list(string))
    service_endpoint_policy_ids            = optional(list(string))
    network_security_group_id              = optional(string)
    route_table_id                         = optional(string)
    nat_gateway_id                         = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))
  }))

  default = {}
}