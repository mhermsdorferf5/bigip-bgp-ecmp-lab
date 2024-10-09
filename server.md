# Linux Server

# Network Config:

ubuntu@ubuntu:~$ cat /etc/netplan/90-static.yaml
```yaml
network:
    version: 2
    ethernets:
        ens6:
          addresses:
          - 10.1.40.9/24
          routes:
          - to: default
            via: 10.1.40.8
```

```bash
sudo netplan apply
```

# Install Docker:
```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y docker.io
```

# Docker Containers
```bash
docker run -d --restart unless-stopped -p 8080:80 f5devcentral/f5-demo-httpd:nginx
docker run -d --restart unless-stopped -p 8081:80 f5devcentral/f5-demo-httpd:nginx
docker run -d --restart unless-stopped -p 8082:80 f5devcentral/f5-demo-httpd:nginx
docker run -d --restart unless-stopped -p 8083:80 f5devcentral/f5-demo-httpd:nginx
```

Check with:
```bash
ubuntu@ubuntu:~$ docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED          STATUS          PORTS                                            NAMES
cad0d704c72e   f5devcentral/f5-demo-httpd:nginx   "/entrypoint.sh ngin…"   31 seconds ago   Up 30 seconds   443/tcp, 0.0.0.0:8083->80/tcp, :::8083->80/tcp   sharp_knuth
24dc3db4ff9f   f5devcentral/f5-demo-httpd:nginx   "/entrypoint.sh ngin…"   35 seconds ago   Up 34 seconds   443/tcp, 0.0.0.0:8082->80/tcp, :::8082->80/tcp   angry_moser
fa6c6b0f4852   f5devcentral/f5-demo-httpd:nginx   "/entrypoint.sh ngin…"   40 seconds ago   Up 39 seconds   443/tcp, 0.0.0.0:8081->80/tcp, :::8081->80/tcp   vibrant_ramanujan
14af2a9db0a7   f5devcentral/f5-demo-httpd:nginx   "/entrypoint.sh ngin…"   47 seconds ago   Up 46 seconds   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp   dreamy_liskov
ubuntu@ubuntu:~$
```