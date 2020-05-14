#####
# Providers
#####

provider "random" {}

provider "kubernetes" {}

#####
# Module
#####

module "this" {
  source = "../../"
}
