resource "docker_image" "traefik" {
  name         = "docker.io/traefik:v2.6"
  keep_locally = false
}

resource "docker_container" "traefik" {
  image    = docker_image.traefik.latest
  name     = "traefik"
  hostname = "traefik"

  command = [
    "--api.insecure=true",
    "--providers.docker"
  ]

  labels {
    label = "traefik.http.routers.treafik.rule"
    value = "Host(`traefik.home.giodamelio.com`)"
  }

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
  }

  networks_advanced {
    name         = docker_network.shared.name
    ipv4_address = "10.155.0.155"
  }
}
