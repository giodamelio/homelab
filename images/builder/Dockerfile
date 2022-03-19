FROM docker.io/alpine:3.15

ARG TERRAFORM_VERSION="1.1.7"

RUN apk add --no-cache curl openssh

RUN ( curl -sLo terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
      unzip terraform.zip && \
      rm terraform.zip && \
      mv ./terraform /usr/local/bin/terraform \
    ) && terraform --version

ENTRYPOINT []
