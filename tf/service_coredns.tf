resource "docker_image" "coredns" {
  name         = "docker.io/coredns/coredns:1.9.0"
  keep_locally = false
}

resource "docker_container" "coredns" {
  image    = docker_image.coredns.latest
  name     = "coredns"
  hostname = "coredns"

  command = ["-dns.port=1053", "-conf=/Corefile"]

  ports {
    external = "1053"
    internal = "1053"
  }

  volumes {
    container_path = "/Corefile"
    host_path      = abspath("../config/coredns/Corefile")
    read_only      = true
  }

  volumes {
    container_path = "/all.hosts"
    host_path      = abspath("../config/coredns/all.hosts")
    read_only      = true
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

# output "ip_address" {
#   value = docker_container.test-whoami.network_data[index(docker_container.test-whoami.network_data.*.network_name, "shared")].ip_address
# }
