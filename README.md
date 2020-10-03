# qazx

Update a DNS record on Cloudflare that points to a dynamic IP address.

## Requirements

- Docker
- Cloudflare token with the following permissions: Zone:Read, DNS:Edit
- **Optional** systemd - service and timer

## Usage

1. **Configuration**

Run `./scripts/configure.sh`.

This script will fill the required Terraform variables with input from you and build the Docker
image.

2. (Optional) **Import an already existing Cloudflare zone**

Run `./scripts/import_zone.sh`.

This script is just a convenience wrapper around

```bash
docker run \
    --env QAZX_CMD=import_zone \
    --rm \
    --volume $(pwd)/dns:/dns qazx:latest
```

**Important!** You may need to run this script with `sudo`. It is completely safe to do so, since
this script just calls docker.

3. (Optional) **Installation**

Run `./scripts/install.sh`.

This script will ask you how often you want to try to update the DNS record, then it will install
and enable the systemd service and timer.

**VERY IMPORTANT!** The systemd service will need access to this directory to find the Terraform
plans. This means you should either not remove this directory, or move it to a more convenient
location and then run the installation script.

This step is optional because:

- I use systemd, therefore I wrote a solution for my needs and
- I do not force you to use systemd if you do not want to

## What does the name mean?

I have no idea. I looked at the keyboard, pressed some buttons and felt happy that I didn't have to
think about a name.

## License

MIT
