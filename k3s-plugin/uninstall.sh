#!/bin/bash

set -euo pipefail

PLUGIN_NAME="k3s-plugin"
PLUGIN_DIR="/boot/config/plugins/${PLUGIN_NAME}"
EMHTTP_PLUGIN_DIR="/usr/local/emhttp/plugins/${PLUGIN_NAME}"
BIN_PATH="/usr/local/bin/k3s"
KUBE_DIR="/etc/rancher/k3s"
DATA_DIR="/var/lib/rancher/k3s"
LOG_DIR="${PLUGIN_DIR}/logs"
LOG_FILE="${LOG_DIR}/uninstall.log"

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

main() {
  require_root

  if [[ -x "${PLUGIN_DIR}/stop.sh" ]]; then
    "${PLUGIN_DIR}/stop.sh" || true
  fi

  log "Removing k3s plugin files."
  rm -f "${BIN_PATH}"
  rm -rf "${KUBE_DIR}"
  rm -rf "${DATA_DIR}"
  rm -rf "${EMHTTP_PLUGIN_DIR}"
  rm -rf "${PLUGIN_DIR}"
}

main "$@"
