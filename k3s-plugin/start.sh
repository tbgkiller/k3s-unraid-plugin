#!/bin/bash

set -euo pipefail

PLUGIN_NAME="k3s-plugin"
PLUGIN_DIR="/boot/config/plugins/${PLUGIN_NAME}"
BIN_PATH="/usr/local/bin/k3s"
KUBE_DIR="/etc/rancher/k3s"
DATA_DIR="/var/lib/rancher/k3s"
STATE_DIR="${PLUGIN_DIR}/state"
LOG_DIR="${PLUGIN_DIR}/logs"
PID_FILE="${STATE_DIR}/k3s.pid"
LOG_FILE="${LOG_DIR}/k3s.log"
KUBECONFIG_FILE="${KUBE_DIR}/k3s.yaml"

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

is_running() {
  if [[ -f "${PID_FILE}" ]]; then
    local pid
    pid="$(cat "${PID_FILE}")"
    if [[ -n "${pid}" ]] && kill -0 "${pid}" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

wait_for_ready() {
  local attempts=60
  local delay=2

  for ((i=1; i<=attempts; i++)); do
    if [[ -f "${KUBECONFIG_FILE}" ]] && "${BIN_PATH}" kubectl get nodes >/dev/null 2>&1; then
      return 0
    fi
    sleep "${delay}"
  done

  return 1
}

main() {
  require_root
  mkdir -p "${STATE_DIR}" "${LOG_DIR}" "${KUBE_DIR}" "${DATA_DIR}"

  if [[ ! -x "${BIN_PATH}" ]]; then
    echo "k3s binary not found at ${BIN_PATH}. Run install.sh first." >&2
    exit 1
  fi

  if is_running; then
    log "k3s is already running with PID $(cat "${PID_FILE}")."
    exit 0
  fi

  log "Starting k3s server."
  nohup "${BIN_PATH}" server \
    --config "${KUBE_DIR}/config.yaml" \
    --data-dir "${DATA_DIR}" \
    >> "${LOG_FILE}" 2>&1 &

  echo $! > "${PID_FILE}"
  log "k3s launched with PID $(cat "${PID_FILE}"). Waiting for readiness."

  if wait_for_ready; then
    log "k3s is ready."
    exit 0
  fi

  log "k3s did not become ready in time. Check ${LOG_FILE}."
  exit 1
}

main "$@"
