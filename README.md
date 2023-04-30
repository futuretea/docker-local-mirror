# docker-local-mirror

## Requirements
- `regctl` from https://github.com/regclient/regclient/releases
- `fd` from https://github.com/sharkdp/fd/releases

## How to use

### Server
1. Prepare a directory for storing the mirror data

```bash
sudo mkdir -p /data/dockerhub
sudo chown -R ${USER} /data/dockerhub
```

2. Run the docker-compose

```bash
cd dockerhub
docker-compose up -d
```

### Client
```bash
vim /etc/docker/daemon.json
```

```json
{
   "registry-mirrors":[
        "http://<replace to the server ip>:5000"
    ],
    "insecure-registries":[
        "http://<replace to the server ip>:5100"
    ],
    "max-concurrent-downloads": 10,
    "log-driver": "json-file",
    "log-level": "warn",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
      "features": {
        "buildkit": true
    }
}

```

### Clean head images daily

```bash
crontab -e
```

Add the following cron job
```cron
0 0 * * * /your-path-to-this-repo/docker-local-mirror/dockerhub/clean.sh head
```