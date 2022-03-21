resource "docker_image" "traefik" {
  name         = "docker.io/traefik:v2.6"
  keep_locally = false
}

locals {
  traefik_labels = {
    "traefik.enable"                                         = "true"
    "traefik.http.routers.traefik.rule"                      = "Host(`traefik.home.giodamelio.com`)"
    "traefik.http.services.traefik.loadbalancer.server.port" = "8080"
    "traefik.http.routers.traefik.tls"                       = "true"
    "traefik.http.routers.traefik.tls.certresolver"          = "le"
  }
}

resource "docker_container" "traefik" {
  image    = docker_image.traefik.latest
  name     = "traefik"
  hostname = "traefik"

  dynamic "labels" {
    for_each = local.traefik_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
  }

  volumes {
    container_path = "/etc/traefik"
    host_path      = "${local.basepath}/config/traefik/"
    read_only      = true
  }

  volumes {
    container_path = "/root/.aws/"
    host_path      = "${local.basepath}/data/traefik/aws_creds"
    read_only      = true
  }

  volumes {
    container_path = "/acme"
    host_path      = "${local.basepath}/data/traefik/acme/"
  }

  networks_advanced {
    name         = docker_network.shared.name
    ipv4_address = "10.155.0.155"
  }
}
