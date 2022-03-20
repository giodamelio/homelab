locals {
  postgres_user = "authentik"
  postgres_db   = "authentik"
}

variable "authentik_postgres_password" {
  type      = string
  sensitive = true
}

variable "authentik_secret_key" {
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

resource "docker_container" "authentik-server" {
  image    = docker_image.authentik_server.latest
  name     = "authentik-server"
  hostname = "authentik-server"

  command = ["server"]

  env = [
    "AUTHENTIK_SECRET_KEY=${var.authentik_secret_key}",
    "AUTHENTIK_REDIS__HOST=${docker_container.authentik-redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${docker_container.authentik-postgres.name}",
    "AUTHENTIK_POSTGRESQL__USER=${local.postgres_user}",
    "AUTHENTIK_POSTGRESQL__PASSWORD=${var.authentik_postgres_password}",
    "AUTHENTIK_POSTGRESQL__NAME=${local.postgres_db}"
  ]

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "authentik-worker" {
  image    = docker_image.authentik_server.latest
  name     = "authentik-worker"
  hostname = "authentik-worker"

  command = ["worker"]

  env = [
    "AUTHENTIK_SECRET_KEY=${var.authentik_secret_key}",
    "AUTHENTIK_REDIS__HOST=${docker_container.authentik-redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${docker_container.authentik-postgres.name}",
    "AUTHENTIK_POSTGRESQL__USER=${local.postgres_user}",
    "AUTHENTIK_POSTGRESQL__PASSWORD=${var.authentik_postgres_password}",
    "AUTHENTIK_POSTGRESQL__NAME=${local.postgres_db}"
  ]

  volumes {
    container_path = "/certs"
    host_path      = "${local.basepath}/data/authentik/certs"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
