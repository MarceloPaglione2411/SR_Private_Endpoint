###TERRAFORM MODULES BLOCK
# Module Resource Group (Import)
module "rg_module" {
  source = "./resource_group"
}

module "networking_module" {
  source = "./networking"
}

module "storage_module" {
  source = "./storage"
}

