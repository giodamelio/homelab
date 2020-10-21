# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.140.1/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version: 3, 3.8, 3.7, 3.6
ARG VARIANT="3"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# Install Ansible and the community.general plugin collection
RUN pip3 install ansible
RUN ansible-galaxy collection install community.general

# Setup ssh keys
COPY .ssh/ /root/.ssh
RUN chmod 600 /root/.ssh/nodes
RUN chmod 600 /root/.ssh/nodes.pub

# Don't verify host keys
# I know this is bad, but I don't know how to get around Ansible asking to
# verify the fingerprints any time the docker container is rebuild
# When it does that it only lets you say yes to the last one
ENV ANSIBLE_HOST_KEY_CHECKING=False