terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Multiple providers requirement: local writes files to disk,
# random generates the DB password. Neither needs cloud credentials,
# which is why this scenario works entirely on your machine.
provider "local" {}
provider "random" {}
