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
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.gitlab.rule"
    value = "Host(`gitlab.home.giodamelio.com`)"
  }

  labels {
    label = "traefik.http.routers.gitlab.service"
    value = "gitlab"
  }

  labels {
    label = "traefik.http.services.gitlab.loadbalancer.server.port"
    value = "80"
  }

  labels {
    label = "traefik.http.routers.gitlab.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.gitlab.tls.certresolver"
    value = "le"
  }

  labels {
    label = "traefik.http.routers.gitlab-docker.rule"
    value = "Host(`docker.home.giodamelio.com`)"
  }

  labels {
    label = "traefik.http.routers.gitlab-docker.service"
    value = "gitlab-docker"
  }

  labels {
    label = "traefik.http.services.gitlab-docker.loadbalancer.server.port"
    value = "5050"
  }

  labels {
    label = "traefik.http.routers.gitlab-docker.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.gitlab-docker.tls.certresolver"
    value = "le"
  }

  volumes {
    container_path = "/var/opt/gitlab"
    host_path      = "${local.basepath}/data/gitlab/data"
  }

  volumes {
    container_path = "/var/log/gitlab"
    host_path      = "${local.basepath}/data/gitlab/logs"
  }

  volumes {
    container_path = "/etc/gitlab"
    host_path      = "${local.basepath}/data/gitlab/config"
  }

  volumes {
    container_path = "/etc/external_config"
    host_path      = "${local.basepath}/data/gitlab/external_config"
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
    host_path      = "${local.basepath}/data/gitlab/runner_config"
  }

  networks_advanced {
    name = docker_network.shared.name
  }
}
