resource "docker_image" "gitlab-ce" {
  name         = "docker.io/gitlab/gitlab-ce:14.8.4-ce.0"
  keep_locally = false
}

# Portainer for easy management of containers
resource "docker_container" "gitlab" {
  image    = docker_image.gitlab-ce.latest
  name     = "gitlab"
  hostname = "gitlab"

  env = [
    "GITLAB_OMNIBUS_CONFIG=from_file \"/etc/external_config/config.rb\""
  ]

  volumes {
    container_path = "/var/opt/gitlab"
    host_path      = abspath("../data/gitlab/data/")
  }

  volumes {
    container_path = "/var/log/gitlab"
    host_path      = abspath("../data/gitlab/logs/")
  }

  volumes {
    container_path = "/etc/gitlab"
    host_path      = abspath("../data/gitlab/config/")
  }

  volumes {
    container_path = "/etc/external_config"
    host_path      = abspath("../data/gitlab/external_config/")
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
