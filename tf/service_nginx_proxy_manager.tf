resource "docker_image" "nginx_proxy_manager" {
  name         = "docker.io/jc21/nginx-proxy-manager:latest"
  keep_locally = false
}

# NGINX Proxy Manager to handle the reverse proxy
resource "docker_container" "nginx_proxy_manager" {
  image    = docker_image.nginx_proxy_manager.latest
  name     = "nginx-proxy-manager"
  hostname = "nginx-proxy-manager"

  ports {
    internal = 80
    external = 8000
  }

  ports {
    internal = 81
    external = 8001
  }

  ports {
    internal = 443
    external = 8443
  }

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.nginx_proxy_manager_data.name
  }

  volumes {
    container_path = "/etc/letsencrypt"
    volume_name    = docker_volume.nginx_proxy_manager_letsencrypt.name
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}

# Volumes to store NGINX Proxy Manager data
resource "docker_volume" "nginx_proxy_manager_data" {
  name = "nginx_proxy_manager_data"
}

resource "docker_volume" "nginx_proxy_manager_letsencrypt" {
  name = "nginx_proxy_manager_letsencrypt"
}
