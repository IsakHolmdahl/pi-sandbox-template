This repo contains a Dockerfile for setting up a Docker sandbox (sbx) for the Pi harness, and is entierly copied from https://github.com/geut/sbx-shell-pi/blob/main/Dockerfile.

The only things added are specific information for my setup in the README.

So, to use this simply run this:

```bash
sbx run -t ghcr.io/isakholmdahl/pi-sandbox-template:latest shell [PROJECT_DIR]
```

Then to add env vars, you can do:

```bash
 sbx exec -d <sandbox-name> bash -c "echo 'export BRAVE_API_KEY=your_key' >> /etc/sandbox-persistent.sh"
```

Build and update the Docker image:

```bash
echo "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | docker login ghcr.io -u isakholmdahl --password-stdin

docker build -t ghcr.io/isakholmdahl/pi-sandbox-template:latest --push .
```
