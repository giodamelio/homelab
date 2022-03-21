resource "docker_image" "whoami" {
  name         = "docker.io/traefik/whoami:latest"
  keep_locally = false
}

resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  labels {
    label = "traefik.http.routers.test-whoami.rule"
    value = "Host(`test-whoami.home.giodamelio.com`)"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "test-whoami-authenticated" {
  image    = docker_image.whoami.latest
  name     = "test-whoami-authenticated"
  hostname = "test-whoami-authenticated"

  networks_advanced {
    name = docker_network.shared.name
  }
}
