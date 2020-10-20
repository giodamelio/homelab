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