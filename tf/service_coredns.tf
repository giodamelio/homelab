resource "docker_image" "coredns" {
  name         = "docker.io/coredns/coredns:1.9.0"
  keep_locally = false
}

# Store the hosts file
resource "docker_volume" "coredns_hosts_file" {
  name = "coredns_hosts_file"
}

# Generate the hosts file for the coredns container
resource "docker_container" "coredns-gen" {
  image    = docker_image.docker-gen.latest
  name     = "coredns-gen"
  hostname = "coredns-gen"

  command = ["-watch", "/etc/docker-gen/templates/all.hosts.tmpl", "/etc/docker-gen/output/all.hosts"]

  volumes {
    container_path = "/tmp/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    container_path = "/etc/docker-gen/templates"
    host_path      = "${local.basepath}/config/coredns/templates"
    read_only      = true
  }

  volumes {
    container_path = "/etc/docker-gen/output"
    volume_name    = docker_volume.coredns_hosts_file.name
  }

  networks_advanced {
    name = docker_network.shared.name
  }
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
    host_path      = "${local.basepath}/config/coredns/Corefile"
    read_only      = true
  }

  volumes {
    container_path = "/config"
    volume_name    = docker_volume.coredns_hosts_file.name
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
