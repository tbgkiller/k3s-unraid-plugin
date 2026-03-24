# k3s Unraid Plugin

Unraid plugin that installs and manages k3s (lightweight Kubernetes) for container orchestration.

## Files

- `k3s-plugin.plg`: Unraid plugin manifest. It downloads the lifecycle scripts and runs `install.sh`.
- `install.sh`: Downloads `k3s v1.35.2+k3s1`, creates the default config, and prepares plugin directories.
- `start.sh`: Launches `k3s server` in the background and waits for the API to become ready.
- `stop.sh`: Stops the background `k3s` process using the saved PID.
- `uninstall.sh`: Stops k3s and removes plugin-managed files and directories.

## Managed Paths

- Binary: `/usr/local/bin/k3s`
- Plugin state: `/boot/config/plugins/k3s-plugin`
- Unraid UI docs: `/usr/local/emhttp/plugins/k3s-plugin`
- k3s config: `/etc/rancher/k3s`
- k3s data: `/var/lib/rancher/k3s`

## Default Behavior

- Installs `k3s v1.35.2+k3s1`
- Writes `/etc/rancher/k3s/config.yaml` if one does not already exist
- Disables bundled `traefik` by default
- Writes kubeconfig with mode `0644`
- Uses `unraid-k3s` as the default node name

## Before Publishing

The `.plg` manifest currently uses placeholder GitHub Raw URLs:

- `https://raw.githubusercontent.com/REPO_OWNER/REPO_NAME/main/phase1-k3s-plugin/...`

Replace those with the final repository path before submitting the plugin to Community Applications.

## Notes

This is a Phase 1 scaffold, not a fully production-hardened Unraid plugin yet. The next iteration should add:

- Boot integration so k3s starts after reboot
- More complete network and iptables cleanup on stop/uninstall
- Health reporting in the Unraid UI
- Update handling and version checks
- Real-world testing on an Unraid host
