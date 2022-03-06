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

# whoami container to use for testing
resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  ports {
    external = "8080"
    internal = "80"
  }
}

# Portainer for easy management of containers
resource "docker_container" "portainer" {
  image    = docker_image.portainer.latest
  name     = "portainer"
  hostname = "portainer"

  ports {
    internal = 8000
    external = 8000
  }

  ports {
    internal = 9443
    external = 9443
  }

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
  }

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.portainer_data.name
  }
}

# Volume to store portainers data
resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}
