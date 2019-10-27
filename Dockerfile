FROM ubuntu:16.04

## Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Docker Compose version
ARG COMPOSE_VERSION=1.24.0
ARG KOMPOSE_VERSION=1.19.0
ARG HELMFILE_VERSION=0.87.1
ARG NODEJS_VERSION=13

## This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
## this user's GID/UID must match your local user UID/GID to avoid permission issues
## with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
## https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

## apt-get and system utilities
RUN apt-get update \
    && apt-get install -yq --no-install-recommends apt-utils dialog 2>&1 \
        apt-transport-https \
        debconf-utils \
        ca-certificates \
        build-essential \
        lsb-release \
        software-properties-common \
        iproute2 \ 
        procps \
        dirmngr \
        iputils-ping \
        net-tools \
        telnet \
        dnsutils \
        nano \
        wget \
        curl \
        p7zip-full p7zip-rar \
        git \
        jq \
        mc \
        # https://linuxize.com/post/how-to-use-linux-screen/
        screen \
    && rm -rf /var/lib/apt/lists/*

## PlantUML https://github.com/microsoft/vscode-dev-containers/blob/master/containers/plantuml/.devcontainer/Dockerfile
RUN apt-get update \
    && apt-get install -yq --no-install-recommends graphviz default-jre \
    && mkdir -p /opt/plantuml \
    && (cd /opt/plantuml; curl -JLO http://sourceforge.net/projects/plantuml/files/plantuml.jar/download) \
    && echo '#!/bin/sh \njava -jar /opt/plantuml/plantuml.jar "$@" \n' > /usr/local/bin/plantuml \
    && chmod a+x /usr/local/bin/plantuml \
    && rm -rf /var/lib/apt/lists/*

## Docker https://github.com/microsoft/vscode-dev-containers/blob/master/containers/kubernetes-helm/.devcontainer/Dockerfile
RUN apt-get update \
    && apt-get install -yq --no-install-recommends apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && curl -sSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && rm -rf /var/lib/apt/lists/*

## Powershell https://github.com/microsoft/vscode-dev-containers/blob/master/containers/powershell/.devcontainer/Dockerfile
## DotNet Core https://github.com/microsoft/vscode-dev-containers/blob/master/containers/dotnetcore-latest/.devcontainer/Dockerfile
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update && apt-get install -yq --no-install-recommends \
        powershell \
        dotnet-sdk-3.0 \
        # dotnet-runtime-3.0 \
        # aspnetcore-runtime-3.0 \
    && rm -rf /var/lib/apt/lists/*

## Azure-CLI https://github.com/microsoft/vscode-dev-containers/blob/master/containers/azure-cli/.devcontainer/Dockerfile
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
    && apt-get update && apt-get install -yq --no-install-recommends \
        azure-cli \
    && rm -rf /var/lib/apt/lists/*

## Google Cloud, Kubectl
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -yq --no-install-recommends \
        google-cloud-sdk \
        kubectl \
    && rm -rf /var/lib/apt/lists/*

## Kompose
RUN curl -L https://github.com/kubernetes/kompose/releases/download/v${KOMPOSE_VERSION}/kompose-linux-amd64 -o kompose \
    && chmod +x kompose \
    && mv ./kompose /usr/local/bin/kompose

## Helm, HelmFile https://github.com/microsoft/vscode-dev-containers/blob/master/containers/kubernetes-helm/.devcontainer/Dockerfile
RUN apt-get update && apt-get install -yq --no-install-recommends sudo \
    && curl -L https://git.io/get_helm.sh | bash \
    && helm init --client-only \
    && mkdir -p ~/.helm/plugins \
    && helm plugin install https://github.com/databus23/helm-diff \
    && helm plugin install https://github.com/futuresimple/helm-secrets \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git \
    && helm plugin install https://github.com/aslafy-z/helm-git.git \
    && helm plugin install https://github.com/rimusz/helm-tiller \
    && curl -L https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 -o /usr/local/bin/helmfile \
    && chmod +x /usr/local/bin/helmfile

## NodeJs w/ NPM https://github.com/microsoft/vscode-dev-containers/blob/master/containers/typescript-node-lts/.devcontainer/Dockerfile
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
    && apt-get update && apt-get install -yq --no-install-recommends \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

## TypeScript, tsLint, Angular, CloudCmd, Gritty
RUN npm config set user 0 \
    && npm install --production -g \
        tslint typescript \
        @angular/cli \
        cloudcmd \
        gritty

## Virtual Screen https://linuxize.com/post/how-to-use-linux-screen/
RUN apt-get update && apt-get install -yq --no-install-recommends \
        screen \
    && rm -rf /var/lib/apt/lists/*

## Oh My Zsh
RUN apt-get update && apt-get install -yq --no-install-recommends \
        fonts-powerline \
        zsh \
    && apt-get update \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="robbyrussell"/g' ~/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(git copydir docker docker-compose helm kubectl minikube node npm ubuntu)/g' ~/.zshrc \
    && rm -rf /var/lib/apt/lists/*

## Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -yq --no-install-recommends sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME

## Clean up
RUN apt-get update \
    && apt-get autoremove -yq \
    && apt-get clean -yq \
    && rm -rf /var/lib/apt/lists/*

## Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

## 
EXPOSE 8000

# ENTRYPOINT ["tail", "-f", "/dev/null"]