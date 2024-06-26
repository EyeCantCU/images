terraform {
  required_providers {
    apko = { source = "chainguard-dev/apko" }
  }
}

variable "extra_packages" {
  description = "The additional packages to install (e.g. tomcat-10)."
  default = [
    "tomcat-10.1",
    "tomcat-10.1-webapps",
    "tomcat-native",
    "openjdk-17",
    "openjdk-17-default-jvm",
  ]
}

data "apko_config" "this" {
  config_contents = file("${path.module}/template.apko.yaml")
  extra_packages  = var.extra_packages
}

output "config" {
  value = jsonencode(data.apko_config.this.config)
}
