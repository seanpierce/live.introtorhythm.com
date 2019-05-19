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

## Setting up the remote server

* Spin up an Ubuntu server > 18.x
* ssh into the server by running `ssh root@[ipaddress]`

### Enabling ssh password authentication

```shell
sudo nano /etc/ssh/sshd_config
```
* Ensure that the row labeled `PermitRootLogin prohibit-password` is changed to `PermitRootLogin yes`
* and `PasswordAuthentication no` is set to `PasswordAuthentication yes`

([Digital Ocean instructions here](https://www.digitalocean.com/community/questions/error-permission-denied-publickey-when-i-try-to-ssh))

### Creating a new user and setting up a basic firewall

```shell
adduser [username]
usermod -aG sudo [username]
ufw app list # output - Available applications: OpenSSH
ufw allow OpenSSH
ufw enable
ufw status # note that OpenSSH is set to ALLOWED
```

([Digital Ocean instructions here](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04))

### Installing docker

* Install docker by following the [Digital Ocean instructions](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) 