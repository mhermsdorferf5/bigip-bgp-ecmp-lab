# Traffic Generator

## Network Config

ubuntu@ubuntu:~$ cat /etc/netplan/90-static.yaml

```yaml
network:
    version: 2
    ethernets:
        ens6:
          addresses:
          - 10.1.40.10/24
          routes:
          - to: default
            via: 10.1.40.8
```

```bash
sudo netplan apply
```

## Install Docker

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y docker.io
```

## Docker Containers

```bash
docker run -d --restart unless-stopped quay.io/curl/curl:latest /bin/sh -c 'while true; do curl -s http://10.100.101.100/txt; sleep .25; done'
docker run -d --restart unless-stopped quay.io/curl/curl:latest /bin/sh -c 'while true; do curl -s http://10.100.101.100/txt; sleep 1; done'
docker run -d --restart unless-stopped quay.io/curl/curl:latest /bin/sh -c 'while true; do curl -s http://10.100.101.100/txt; sleep .5; done'
```

Check with:

```bash
ubuntu@ubuntu:~$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS         PORTS     NAMES
be66b3b112e6   quay.io/curl/curl:latest   "/entrypoint.sh /bin…"   9 seconds ago    Up 8 seconds             hopeful_solomon
14cd693ed8e2   quay.io/curl/curl:latest   "/entrypoint.sh /bin…"   9 seconds ago    Up 8 seconds             gallant_joliot
16322a7059e0   quay.io/curl/curl:latest   "/entrypoint.sh /bin…"   10 seconds ago   Up 9 seconds             nervous_bartik
ubuntu@ubuntu:~$
```
