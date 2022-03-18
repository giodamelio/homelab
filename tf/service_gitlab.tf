resource "docker_image" "gitlab-ce" {
  name         = "docker.io/gitlab/gitlab-ce:14.8.4-ce.0"
  keep_locally = false
}

resource "docker_image" "gitlab-runner" {
  name         = "docker.io/gitlab/gitlab-runner:v14.8.2"
  keep_locally = false
}

# Gitlab
resource "docker_container" "gitlab" {
  image    = docker_image.gitlab-ce.latest
  name     = "gitlab"
  hostname = "gitlab"

  env = [
    "GITLAB_OMNIBUS_CONFIG=from_file \"/etc/external_config/config.rb\""
  ]

  labels {
    label = "ProxyAdditionalHost"
    value = "docker.home.giodamelio.com"
  }

  labels {
    label = "ProxyAdditionalPort"
    value = "5050"
  }

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

# Gitlab runner
resource "docker_container" "gitlab-runner" {
  image    = docker_image.gitlab-runner.latest
  name     = "gitlab-runner"
  hostname = "gitlab-runner"

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
  }

  volumes {
    container_path = "/etc/gitlab-runner"
    host_path      = abspath("../data/gitlab/runner_config/")
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
