#!/bin/bash

set -euo pipefail

PLUGIN_NAME="k3s-plugin"
K3S_VERSION="v1.35.2+k3s1"
K3S_VERSION_URLENCODED="v1.35.2%2Bk3s1"
K3S_BINARY_URL="https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION_URLENCODED}/k3s"
PLUGIN_DIR="/boot/config/plugins/${PLUGIN_NAME}"
EMHTTP_PLUGIN_DIR="/usr/local/emhttp/plugins/${PLUGIN_NAME}"
BIN_PATH="/usr/local/bin/k3s"
KUBE_DIR="/etc/rancher/k3s"
DATA_DIR="/var/lib/rancher/k3s"
STATE_DIR="${PLUGIN_DIR}/state"
LOG_DIR="${PLUGIN_DIR}/logs"
LOG_FILE="${LOG_DIR}/install.log"

log() {
  mkdir -p "${LOG_DIR}"
  echo "[${PLUGIN_NAME}] $*" | tee -a "${LOG_FILE}"
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must run as root." >&2
    exit 1
  fi
}

download_binary() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${K3S_BINARY_URL}" -o "${BIN_PATH}"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO "${BIN_PATH}" "${K3S_BINARY_URL}"
    return
  fi

  log "Neither curl nor wget is available."
  exit 1
}

write_default_config() {
  local config_path="${KUBE_DIR}/config.yaml"

  if [[ -f "${config_path}" ]]; then
    log "Existing config found at ${config_path}; leaving it in place."
    return
  fi

  cat > "${config_path}" <<'EOF'
write-kubeconfig-mode: "0644"
disable:
  - traefik
node-name: unraid-k3s
EOF
  log "Wrote default k3s config to ${config_path}."
}

main() {
  require_root

  mkdir -p "${PLUGIN_DIR}" "${EMHTTP_PLUGIN_DIR}" "${KUBE_DIR}" "${DATA_DIR}" "${STATE_DIR}" "${LOG_DIR}"

  log "Installing k3s ${K3S_VERSION}."
  download_binary
  chmod 0755 "${BIN_PATH}"
  write_default_config

  if [[ -f "${PLUGIN_DIR}/README.md" ]]; then
    cp -f "${PLUGIN_DIR}/README.md" "${EMHTTP_PLUGIN_DIR}/README.md"
  fi

  log "k3s binary installed to ${BIN_PATH}."
  log "Plugin files are available in ${PLUGIN_DIR}."
  log "Use ${PLUGIN_DIR}/start.sh to launch the server."
}

main "$@"
