resource "docker_image" "factorio" {
  name = "factorio:latest"

  build {
    path = abspath("../images/factorio")
    tag  = ["factorio:latest"]
  }
}

# Portainer for easy management of containers
resource "docker_container" "factorio-space" {
  image    = docker_image.factorio.latest
  name     = "factorio-space"
  hostname = "factorio-space"

  volumes {
    container_path = "/srv/factorio/mods"
    host_path      = abspath("../data/factorio-space/mods/")
  }

  volumes {
    container_path = "/srv/saves"
    host_path      = abspath("../data/factorio-space/saves/")
  }

  volumes {
    container_path = "/srv/server_configs"
    host_path      = abspath("../data/factorio-space/server_configs/")
  }

  volumes {
    container_path = "/var/lib/tailscale"
    host_path      = abspath("../data/factorio-space/tailscale/")
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
