variable "name" {
  type        = string
  description = "The name of the virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the virtual network is created."
}

variable "location" {
  type        = string
  description = "The Azure region for the virtual network."
}

variable "address_space" {
  type        = list(string)
  description = "The address space for the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  description = "Optional custom DNS servers for the virtual network."
  default     = []
}

variable "edge_zone" {
  type        = string
  description = "Optional edge zone for the virtual network."
  default     = null
}

variable "flow_timeout_in_minutes" {
  type        = number
  description = "Optional flow timeout in minutes for the virtual network."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags assigned to the virtual network."
  default     = {}
}