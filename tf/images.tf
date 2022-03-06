resource "docker_image" "whoami" {
  name         = "docker.io/traefik/whoami:latest"
  keep_locally = false
}

resource "docker_image" "portainer" {
  name         = "docker.io/portainer/portainer-ce:2.11.1-alpine"
  keep_locally = false
}