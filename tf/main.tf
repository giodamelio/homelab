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
  # host = "unix:///var/run/docker.sock"
  host     = "ssh://server@10.0.0.198:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

locals {
  basepath = "/home/server/homelab"
}

# Shared network that all the containers will use
resource "docker_network" "shared" {
  name = "shared"

  ipam_config {
    gateway = "10.155.0.1"
    subnet  = "10.155.0.0/16"
  }
}

# Images shared between multiple services
resource "docker_image" "docker-gen" {
  name         = "docker.io/jwilder/docker-gen:0.8.3"
  keep_locally = false
}

resource "docker_image" "postgres" {
  name = "docker.io/postgres:14-alpine"
}

resource "docker_image" "redis" {
  name = "docker.io/redis:6.2"
}
