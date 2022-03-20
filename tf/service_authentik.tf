locals {
  postgres_user = "authentik"
  postgres_db   = "authentik"
}

variable "authentik_postgres_password" {
  type      = string
  sensitive = true
}

resource "docker_image" "authentik_server" {
  name = "ghcr.io/goauthentik/server:2022.3.2"
}

resource "docker_container" "authentik-redis" {
  image    = docker_image.redis.latest
  name     = "authentik-redis"
  hostname = "authentik-redis"

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "authentik-postgres" {
  image    = docker_image.postgres.latest
  name     = "authentik-postgres"
  hostname = "authentik-postgres"

  env = [
    "POSTGRES_USER=${local.postgres_user}",
    "POSTGRES_PASSWORD=${var.authentik_postgres_password}",
    "POSTGRES_DB=${local.postgres_db}"
  ]

  volumes {
    container_path = "/var/lib/postgresql/data"
    host_path      = "${local.basepath}/data/authentik/postgres_data"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
