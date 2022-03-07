resource "docker_image" "whoami" {
  name         = "docker.io/traefik/whoami:latest"
  keep_locally = false
}

resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  networks_advanced {
    name = docker_network.shared.name
  }
}

output "ip_address" {
  value = docker_container.test-whoami.network_data[index(docker_container.test-whoami.network_data.*.network_name, "shared")].ip_address
}
