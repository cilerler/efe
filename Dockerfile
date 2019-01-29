FROM ubuntu:16.04

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        debconf-utils \
        ca-certificates \
        build-essential \
        lsb-release \
        software-properties-common \
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
        graphviz \
        default-jre \
        mc \
    && rm -rf /var/lib/apt/lists/*

## PlantUML
RUN mkdir -p /opt/plantuml \
    && (cd /opt/plantuml; curl -JLO http://sourceforge.net/projects/plantuml/files/plantuml.jar/download) \
    && echo '#!/bin/sh \njava -jar /opt/plantuml/plantuml.jar "$@" \n' > /usr/local/bin/plantuml \
    && chmod a+x /usr/local/bin/plantuml \
    && rm -rf /var/lib/apt/lists/*

## Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y \
        gnupg-agent \    
        docker-ce \
    && curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && rm -rf /var/lib/apt/lists/*

## Powershell, DotNet Core
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y \
        powershell \
        # aspnetcore-runtime-2.2 \
        # dotnet-runtime-2.2 \
        dotnet-sdk-2.2 \
    && rm -rf /var/lib/apt/lists/*

## Azure-CLI
RUN AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF \
    && apt-get update && apt-get install -y \
        azure-cli \
    && rm -rf /var/lib/apt/lists/*

## Google Cloud, Kubectl
RUN export CLOUD_SDK_REPO="cloud-sdk-xenial" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \ 
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update && apt-get install -y \
        google-cloud-sdk \
        kubectl \
    && rm -rf /var/lib/apt/lists/*

## NodeJs w/ NPM 
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update && apt-get install -y \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

## Angular, CloudCmd, Gritty
RUN npm config set user 0 \
    && npm install --production -g \
        @angular/cli \
        cloudcmd \
        gritty

## Oh My Zsh
RUN apt-get update && apt-get install -y \
        fonts-powerline \
        zsh \
    && apt-get update \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="robbyrussell"/g' ~/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(git copydir docker docker-compose helm kubectl minikube node npm ubuntu)/g' ~/.zshrc \
    && rm -rf /var/lib/apt/lists/*

## Ensure update
RUN apt-get update



EXPOSE 8000

# ENTRYPOINT ["tail", "-f", "/dev/null"]