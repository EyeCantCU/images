terraform {
  required_providers {
    apko = { source = "chainguard-dev/apko" }
  }
}

variable "component" {
  default = {}
}

locals {
  commands = {
    "manager" : "java -Xms256m -Xmx2048m -Djdk.tls.rejectClientInitiatedRenegotiation=true -jar /usr/local/bin/admin-assembly-1.0.jar",
  }

  paths = {
    "manager" : [{
      path        = "/etc/neuvector"
      type        = "directory"
      uid         = module.accts.block.run-as
      gid         = module.accts.block.run-as
      permissions = 493
      recursive   = true
    }],
  }

  users = {
    "manager" : "manager",
  }

  work-dirs = {
    "manager" : "/",
  }
}

variable "extra_packages" {
  description = "The additional packages to install."
  type        = list(string)
  default     = []
}

variable "environment" {
  default = {}
}

module "accts" {
  source = "../../../tflib/accts"
  run-as = 65532
  uid    = 65532
  gid    = 65532
  name   = local.users[var.component]
}

output "config" {
  value = jsonencode({
    contents = {
      packages = var.extra_packages
    }
    entrypoint = {
      command = local.commands[var.component]
    }
    accounts    = module.accts.block
    environment = var.environment
    paths       = local.paths[var.component]
    work-dir    = local.work-dirs[var.component]
  })
}
