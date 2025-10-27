#!/usr/bin/env bash
# StrongSwan updown failover helper (non-blocking, route/unroute aware)
set -euo pipefail

PRIMARY="azure-gw1"
BACKUP="azure-gw2"
IPSEC="/usr/sbin/ipsec"

log() { logger -t azure-ipsec-failover -- "$@"; }
run_async() { nohup "$IPSEC" "$@" >/dev/null 2>&1 & }

case "${PLUTO_VERB:-}" in
  up-client|up-host)
    if [[ "${PLUTO_CONNECTION:-}" == "$PRIMARY" ]]; then
      log "Primary up; unroute+down backup"
      run_async unroute "$BACKUP"
      run_async down "$BACKUP"
      run_async route "$PRIMARY"
    elif [[ "${PLUTO_CONNECTION:-}" == "$BACKUP" ]]; then
      log "Backup up; unroute+down primary"
      run_async unroute "$PRIMARY"
      run_async down "$PRIMARY"
      run_async route "$BACKUP"
    fi
    ;;
  down-client|down-host)
    if [[ "${PLUTO_CONNECTION:-}" == "$PRIMARY" ]]; then
      log "Primary down; route+up backup"
      run_async route "$BACKUP"
      run_async up "$BACKUP"
    elif [[ "${PLUTO_CONNECTION:-}" == "$BACKUP" ]]; then
      log "Backup down; route+up primary"
      run_async route "$PRIMARY"
      run_async up "$PRIMARY"
    fi
    ;;
  *)
    : ;;
esac
