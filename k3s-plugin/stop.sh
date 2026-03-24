#!/bin/bash

set -euo pipefail

PLUGIN_NAME="k3s-plugin"
PLUGIN_DIR="/boot/config/plugins/${PLUGIN_NAME}"
STATE_DIR="${PLUGIN_DIR}/state"
LOG_DIR="${PLUGIN_DIR}/logs"
PID_FILE="${STATE_DIR}/k3s.pid"
LOG_FILE="${LOG_DIR}/k3s.log"

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

  if [[ ! -f "${PID_FILE}" ]]; then
    log "No PID file found; k3s is not running."
    exit 0
  fi

  local pid
  pid="$(cat "${PID_FILE}")"

  if [[ -z "${pid}" ]] || ! kill -0 "${pid}" 2>/dev/null; then
    log "Stale PID file detected; removing ${PID_FILE}."
    rm -f "${PID_FILE}"
    exit 0
  fi

  log "Stopping k3s process ${pid}."
  kill "${pid}"

  for _ in $(seq 1 30); do
    if ! kill -0 "${pid}" 2>/dev/null; then
      rm -f "${PID_FILE}"
      log "k3s stopped cleanly."
      exit 0
    fi
    sleep 1
  done

  log "k3s did not stop after 30 seconds; sending SIGKILL."
  kill -9 "${pid}"
  rm -f "${PID_FILE}"
}

main "$@"
