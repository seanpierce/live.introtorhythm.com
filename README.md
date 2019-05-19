# Icecast Server Environment

## Installation

```shell
git clone [this repo] && cd [this repo]
docker build . -t [tag] -f ./dockerfile
docker run -d --name icecast_container -p 8000:8000 [tag]
```

## Traversing the container

```shell
# navigate into the container
docker exec -t -i icecast_container /bin/sh
# leave the container
exit
```

## Stopping or removing the container

```shell
docker ps # prints a list of running containers
docker container stop [CONTAINER ID]
docker container rm [CONTAINER ID]
```