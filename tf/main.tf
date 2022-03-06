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

resource "docker_image" "whoami" {
  name = "docker.io/traefik/whoami:latest"
}

resource "docker_container" "test-whoami" {
  image    = docker_image.whoami.latest
  name     = "test-whoami"
  hostname = "test-whoami"

  ports {
    external = "8000"
    internal = "80"
  }
}