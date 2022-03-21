resource "docker_image" "whoami" {
  name         = "docker.io/traefik/whoami:latest"
  keep_locally = false
}

locals {
  test-whoami_labels = {
    "traefik.enable"                                    = "true"
    "traefik.http.routers.test-whoami.rule"             = "Host(`test-whoami.home.giodamelio.com`)"
    "traefik.http.routers.test-whoami.tls"              = "true"
    "traefik.http.routers.test-whoami.tls.certresolver" = "le"
  }

  test-whoami-authenticated_labels = {
    "traefik.enable"                                                  = "true"
    "traefik.http.routers.test-whoami-authenticated.rule"             = "Host(`test-whoami-authenticated.home.giodamelio.com`)"
    "traefik.http.routers.test-whoami-authenticated.tls"              = "true"
    "traefik.http.routers.test-whoami-authenticated.tls.certresolver" = "le"
  }
}

resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  dynamic "labels" {
    for_each = local.test-whoami_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "test-whoami-authenticated" {
  image    = docker_image.whoami.latest
  name     = "test-whoami-authenticated"
  hostname = "test-whoami-authenticated"

  dynamic "labels" {
    for_each = local.test-whoami-authenticated_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
