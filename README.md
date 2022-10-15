[![](http://dockeri.co/image/cilerler/efe)](https://hub.docker.com/r/cilerler/efe)

<!-- ![shields.io](https://img.shields.io/badge/docker-cilerler%2Fefe-blue.svg?logo=docker) -->

[![](https://images.microbadger.com/badges/version/cilerler/efe:latest.svg) ![](https://images.microbadger.com/badges/image/cilerler/efe.svg)](https://microbadger.com/images/cilerler/efe "inspect on microbadger.com")

# efe

## Dev-Ops terminal *(except the IDE)*

### Run remote image *(no build need)*

```powershell
docker run --interactive --tty --volume C:\!\data.ignore\efe\.config:/root/.config cilerler/efe:latest pwsh
kubectl run -i --tty --image cilerler/efe:latest devsecops --restart=Never --wait --rm pwsh;
kubectl run -i --tty --image cilerler/efe:latest devsecops --restart=Never --wait --rm bash;
```

OR

```powershell
docker run -it -v C:\!\data.ignore\efe\.config:/root/.config cilerler/efe:latest bash
```

OR

```powershell
docker run -it -v C:\!\data.ignore\efe\.config:/root/.config cilerler/efe:latest zsh
```

### Stop and remove all exited containers

```powershell
docker rm $(docker stop $(docker ps --quiet --all --filter status=exited --filter ancestor=cilerler/efe --filter ancestor=cilerler/efe:local))
```

### Run local image

!!! tip Build local image

    ```powershell
    docker build --rm . -t cilerler/efe:local;
    ```

*(change the `:latest` to `:local` in the command line starts with `docker run`)*


!!! tip

    ```powershell
    --volume        /:/mnt/fs                  # Mount all including container itself
    --volume       /c:/mnt/HostDriveC
    --volume        ~:/root/HostDirectoryHome
    --volume ~/source:/root/source
    ```

### Additional samples

```powershell
docker run --rm -it -v ${PWD}:/workspace -v ~/AppData/Roaming/gcloud:/root/.config:ro -v ~/.kube:/root/.kube:ro cilerler/efe:local /bin/bash
```


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
