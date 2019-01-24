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
        vim \
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
        && chmod a+x /usr/local/bin/plantuml

## Powershell, DotNet Core
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y \
        powershell \
        # aspnetcore-runtime-2.2
        # dotnet-runtime-2.2
        dotnet-sdk-2.2

## Azure-CLI
RUN AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF \
    && apt-get update && apt-get install -y \
        azure-cli

## Google Cloud, Kubectl
RUN export CLOUD_SDK_REPO="cloud-sdk-xenial" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \ 
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update && apt-get install -y \
        google-cloud-sdk \
        kubectl

## NodeJs w/ NPM 
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update && apt-get install -y \
        nodejs

## Angular, CloudCmd, Gritty
RUN npm config set user 0 \
    && npm install --production -g \
        @angular/cli \
        cloudcmd \
        gritty

## Clear out the local repository of retrieved package files
RUN apt-get clean

EXPOSE 8000

# ENTRYPOINT ["tail", "-f", "/dev/null"]
