resource "docker_image" "traefik" {
  name         = "docker.io/traefik:v2.6"
  keep_locally = false
}

resource "docker_container" "traefik" {
  image    = docker_image.traefik.latest
  name     = "traefik"
  hostname = "traefik"

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.traefik.rule"
    value = "Host(`traefik.home.giodamelio.com`)"
  }

  labels {
    label = "traefik.http.services.traefik.loadbalancer.server.port"
    value = "8080"
  }

  labels {
    label = "traefik.http.routers.traefik.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.traefik.tls.certresolver"
    value = "le"
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
