This repo contains a Dockerfile for setting up a Docker sandbox (sbx) for the Pi harness, and is entierly copied from https://github.com/geut/sbx-shell-pi/blob/main/Dockerfile.

The only things added are specific information for my setup in the README.

## Pi settings

The `settings.json` file in this repo is copied into the image at `/home/agent/.pi/agent/settings.json` during the Docker build, so it acts as the global pi settings for the sandbox. Edit it to change defaults like theme, provider, model, compaction, retry behavior, etc. See https://pi.dev/docs/latest/settings for all available options.

### Pre-installed pi packages

Add package names (one per line) to `pi-packages.txt` in `npm:package-name` format, e.g.:

```
npm:pi-skills
```

During the Docker build, each line is passed to `pi install` so packages are baked into the image — no download delay on first run.

## Usage

To use this simply run this:

```bash
sbx run -t ghcr.io/isakholmdahl/pi-sandbox-template:latest shell [PROJECT_DIR]
```

Then to add env vars, you can do:

```bash
 sbx exec -d <sandbox-name> bash -c "echo 'export BRAVE_API_KEY=your_key' >> /etc/sandbox-persistent.sh"
```

The setup process i suggest you follow is to run the agent, set up provider and default model, add packages and settings you know you will always want and finally create a template from your created sandbox by running:

```bash
sbx template save name-of-sandbox my-template:v1
```

This will save the sandbox as a template that you can then use to create new sandboxes with the same setup, without having to go through the setup process again. 
