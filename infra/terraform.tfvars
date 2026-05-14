project_name = "learn-tf"
environment  = "dev"
location     = "westeurope"

tags = {
  environment = "dev"
  project     = "learn-tf"
}

vnet = {
  address_space = ["10.10.0.0/16"]
  dns_servers   = []
}

subnets = {
  web = {
    address_prefixes                  = ["10.10.1.0/24"]
    service_endpoints                 = ["Microsoft.Storage"]
    private_endpoint_network_policies = "Enabled"
  }

  app = {
    address_prefixes                  = ["10.10.2.0/24"]
    private_endpoint_network_policies = "Enabled"
    delegation = [
      {
        name = "appservice-delegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    ]
  }
}