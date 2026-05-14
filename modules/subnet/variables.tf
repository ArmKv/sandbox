variable "resource_group_name" {
  type        = string
  description = "The resource group that contains the virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network that will contain the subnets."
}

variable "subnets" {
  description = "Subnet definitions keyed by logical subnet name."

  type = map(object({
    name                                   = optional(string)
    address_prefixes                       = list(string)
    default_outbound_access_enabled        = optional(bool)
    private_endpoint_network_policies      = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                      = optional(set(string))
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