# Docker with Google Chrome, Node 23 and lighthouse chrome-launcher GUI

This project provides a simple Docker container with Node.js, Google Chrome, and Lighthouse pre-installed for website performance audits.

## Features

- Google Chrome with GUI support via X Server.
- Lighthouse pre-installed for website audits.
- Audit reports saved automatically in a shared folder on the host machine.

## Requirements

Before using the container, ensure the following requirements are met:

1. **Docker** is installed on your system. ([Install Docker](https://www.docker.com/get-started))
2. **X Server (VcXsrv)** is installed and running (for Windows users):
   - Download and install from [vcxsrv](https://vcxsrv.com/).

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/your-repository-name.git
cd your-repository-name
```

### 2. Build the Docker Image

```bash
docker build -t chrome-node-lighthouse .
```

### 3. Run the Audit with Lighthouse

```bash
 docker run -it --rm `
     -e DISPLAY=$env:DISPLAY `
     -v /tmp/.X11-unix:/tmp/.X11-unix `
     -v ${pwd}/shared:/shared `
     chrome-node-lighthouse /bin/bash
```

and then

```bash
lighthouse https://upwork.com --chrome-flags="--no-sandbox --disable-dev-shm-usage" --output html --output-path /shared/audit-report.html
```

## Troubleshooting

### Error DISPLAY not set

- Ensure your X Server (VcXsrv) is running on your host machine.
- Set the DISPLAY environment variable to your host IP. For example:

```bash
$env:DISPLAY="192.161.0.0:0.0"
```

running this before the step 3. Run the Audit with Lighthouse
