resource "docker_image" "portainer" {
  name         = "docker.io/portainer/portainer-ce:2.11.1-alpine"
  keep_locally = false
}

locals {
  labels = {
    ProxyPort = "9000"
  }
}

# Portainer for easy management of containers
resource "docker_container" "portainer" {
  image    = docker_image.portainer.latest
  name     = "portainer"
  hostname = "portainer"

  dynamic "labels" {
    for_each = local.labels

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
    container_path = "/data"
    host_path      = "${local.basepath}/data/portainer/data"
  }

  networks_advanced {
    name = docker_network.shared.name
  }

  healthcheck {
    test         = ["CMD", "wget", "http://localhost:9000/api/status", "-O", "-"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "3s"
  }
}

# Volume to store portainers data
resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}
