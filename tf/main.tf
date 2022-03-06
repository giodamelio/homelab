terraform {
  backend "s3" {
    bucket = "gio-homelab-tf-state"
    key    = "lab.tfstate"

    # Fake region becuase it is required, but overridden by the endpoint
    region                      = "us-west-1"
    endpoint                    = "https://s3.us-west-001.backblazeb2.com"
    skip_credentials_validation = true
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Shared network that all the containers will use
resource "docker_network" "shared" {
  name = "shared"
}

# whoami container to use for testing
resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  networks_advanced {
    name = docker_network.shared.name
  }
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
