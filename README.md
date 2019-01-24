[![](http://dockeri.co/image/cilerler/efe)](https://hub.docker.com/r/cilerler/efe)

<!-- ![shields.io](https://img.shields.io/badge/docker-cilerler%2Fefe-blue.svg?logo=docker) -->

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
docker run -v C:\!\data.ignore\efe\.config:/root/.config -it cilerler/efe:latest pwsh;
```

### Run local image

!!! tip Build local image

    ```powershell
    docker build . -t cilerler/efe:local;
    ```

*(change the `:latest` to `:local` in the command line starts with `docker run`)*


!!! tip

    `-v ~:/root`  
    `-v /:/mnt/fs`


## Cloud Commander with terminal via Gritty

```powershell
cloudcmd --terminal --terminal-path `gritty --path` --save
```