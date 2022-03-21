resource "docker_image" "whoami" {
  name         = "docker.io/traefik/whoami:latest"
  keep_locally = false
}

resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.test-whoami.rule"
    value = "Host(`test-whoami.home.giodamelio.com`)"
  }

  labels {
    label = "traefik.http.routers.test-whoami.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.test-whoami.tls.certresolver"
    value = "le"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "test-whoami-authenticated" {
  image    = docker_image.whoami.latest
  name     = "test-whoami-authenticated"
  hostname = "test-whoami-authenticated"

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.test-whoami-authenticated.rule"
    value = "Host(`test-whoami-authenticated.home.giodamelio.com`)"
  }

  labels {
    label = "traefik.http.routers.test-whoami-authenticated.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.test-whoami-authenticated.tls.certresolver"
    value = "le"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
