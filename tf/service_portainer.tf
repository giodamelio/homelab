resource "docker_image" "portainer" {
  name         = "docker.io/portainer/portainer-ce:2.11.1-alpine"
  keep_locally = false
}

# Portainer for easy management of containers
resource "docker_container" "portainer" {
  image    = docker_image.portainer.latest
  name     = "portainer"
  hostname = "portainer"

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
  }

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.portainer_data.name
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
