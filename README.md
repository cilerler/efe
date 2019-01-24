[![](http://dockeri.co/image/cilerler/efe)](https://hub.docker.com/r/cilerler/efe)

<!-- ![shields.io](https://img.shields.io/badge/docker-cilerler%2Fefe-blue.svg?logo=docker) -->

[![](https://images.microbadger.com/badges/version/cilerler/efe:latest.svg) ![](https://images.microbadger.com/badges/image/cilerler/efe.svg)](https://microbadger.com/images/cilerler/efe "inspect on microbadger.com")

# efe

## Kubernetes on Docker-Desktop

### Deploy docker-compose to Kubernetes

```powershell
docker stack deploy --namespace myapps --compose-file docker-compose.yml mystack;

```

### Remove deployed stack from Kubernetes

```powershell
docker stack remove --namespace myapps mystack;
```

## Dev-Ops terminal *(except the IDE)*

### Run remote image *(no build need)*

```powershell
# use `bash` instead of `pwsh` if you want a bash shell
docker run -v C:\!\data.ignore\efe\.config:/root/.config -it cilerler/efe:latest pwsh;
```

### Run local image

!!! tip Build local image

    ```powershell
    docker build --rm . -t cilerler/efe:local;
    ```

*(change the `:latest` to `:local` in the command line starts with `docker run`)*


!!! tip

    `-v ~:/root`  
    `-v /:/mnt/fs`


## Cloud Commander with terminal via Gritty

```powershell
cloudcmd --terminal --terminal-path `gritty --path` --save
```

## Midnight Commander

```powershell
mc
```

## PlantUml

```powershell
plantuml <filename>.puml
```
