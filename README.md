# Icecast Server Environment

## Installation and container setup

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

Digital Ocean instructions for enabling ssh password authentication can be found [here](https://www.digitalocean.com/community/questions/error-permission-denied-publickey-when-i-try-to-ssh).

### Creating a new user and setting up a basic firewall

```shell
adduser [username]
usermod -aG sudo [username]
ufw app list # output - Available applications: OpenSSH
ufw allow OpenSSH
ufw enable
ufw status # note that OpenSSH is set to ALLOWED
```

Digital Ocean instructions for basic server setup proceedures can be found [here](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04).

### Installing docker

```shell
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
```

Digital Ocean instructions for installing docker can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04).

Next, clone this repo onto the remote machine, build and run the container using the same instructions outlined above in the _Installation and container setup_ section.

### Adjusting firewall settings

Before Nginx can serve the icecast container to the web, you'll need to adjust the server's firewall rules to allow access to he service.

Check the list of available services:

```shell
sudo ufw app list
```

Output:

```env
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
```

Enable both HTTP and HTTPS:

```shell
sudo ufw allow 'Nginx Full'
```

At this point, you should be able to visit your server's IP address to see the default Nginx page, or http://[ipaddress]:8000 to see the icecast homepage.

Digital Ocean instructions for adjusting firewall settings can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04).

### SSL certificate setup

LetsEncrypt's certbot has an excellend command line tool used to create and manage free ssl certificates.

```shell
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx 
```

Once installation is complete, run the command below, and follow along with the instructional prompts.

```shell
sudo certbot --nginx
```

Detailed instructions for this process can be found on the certbot site [here](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx).

### Setup icecast to run on secure port

From your remote server, navigate into the shell of the docker container per the instructions in the _Traversing the container_ section:

```shell
docker exec -t -i icecast_container /bin/sh
```

Modify the icecast.xml and enable a new _listen-socket_ on port: 8443, with the _ssl_ attribute set to 1:

```shell
nano etc/icecast.xml
```

Documnetation pertaining to the icecast configuration file can be found [here](http://icecast.org/docs/icecast-2.4.1/config-file.html).