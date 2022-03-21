resource "docker_image" "caddy" {
  name = "caddy"

  build {
    path = "${local.basepath}/images/proxy"
    tag  = ["caddy:latest"]
  }
}

# Store the hosts file
resource "docker_volume" "proxy_caddyfile" {
  name = "proxy_caddyfile"
}

# Generate the hosts file for the coredns container
resource "docker_container" "proxy-gen" {
  image    = docker_image.docker-gen.latest
  name     = "proxy-gen"
  hostname = "proxy-gen"

  command = [
    "-watch",
    "-notify-container", docker_container.proxy.name,
    "-notify-signal", "10", # SIGUSR1
    "/etc/docker-gen/templates/Caddyfile.tmpl",
    "/etc/docker-gen/output/Caddyfile"
  ]

  volumes {
    container_path = "/tmp/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    container_path = "/etc/docker-gen/templates"
    host_path      = "${local.basepath}/config/proxy/templates"
    read_only      = true
  }

  volumes {
    container_path = "/etc/docker-gen/output"
    volume_name    = docker_volume.proxy_caddyfile.name
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

resource "docker_container" "proxy" {
  image    = docker_image.caddy.latest
  name     = "proxy"
  hostname = "proxy"

  volumes {
    container_path = "/etc/caddy/"
    volume_name    = docker_volume.proxy_caddyfile.name
  }

  volumes {
    container_path = "/root/.aws/"
    host_path      = "${local.basepath}/data/proxy/aws_creds"
    read_only      = true
  }

  volumes {
    container_path = "/data"
    host_path      = "${local.basepath}/data/proxy/data"
  }
}
