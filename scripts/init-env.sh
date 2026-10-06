#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file="${PCFREE_ENV_FILE:-$repo_root/.env}"
example_file="$repo_root/.env.example"

log() { printf '[PC-Free] %s\n' "$*"; }
fail() { printf '[PC-Free] Error: %s\n' "$*" >&2; exit 1; }

random_hex() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 12
  elif [ -r /dev/urandom ]; then
    od -An -N12 -tx1 /dev/urandom | tr -d ' \n'
  else
    fail 'A secure random-number generator is required (openssl or /dev/urandom).'
  fi
}

[ -f "$example_file" ] || fail ".env.example was not found at $example_file"
umask 077

if [ -e "$env_file" ]; then
  [ -f "$env_file" ] || fail "$env_file exists but is not a regular file."
  chmod 600 "$env_file"
  log 'Existing .env kept unchanged.'
else
  username="${PCFREE_WINDOWS_USERNAME:-PCFree}"
  password="${PCFREE_WINDOWS_PASSWORD:-PcF-$(random_hex)-A9}"

  if [[ ! "$username" =~ ^[A-Za-z0-9._-]{1,20}$ ]]; then
    fail 'PCFREE_WINDOWS_USERNAME must contain 1-20 letters, numbers, dots, underscores, or hyphens.'
  fi
  if (( ${#password} < 12 )); then
    fail 'PCFREE_WINDOWS_PASSWORD must be at least 12 characters.'
  fi
  if [[ ! "$password" =~ ^[A-Za-z0-9._@%+=:-]+$ ]]; then
    fail 'PCFREE_WINDOWS_PASSWORD contains characters that are unsafe in an env file.'
  fi

  mkdir -p "$(dirname "$env_file")"
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      WINDOWS_USERNAME=*) printf 'WINDOWS_USERNAME=%s\n' "$username" ;;
      WINDOWS_PASSWORD=*) printf 'WINDOWS_PASSWORD=%s\n' "$password" ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < "$example_file" > "$env_file"
  chmod 600 "$env_file"
  log 'Created .env with a generated Windows password.'
fi

mkdir -p "$repo_root/windows" "$repo_root/shared"
log 'Persistent folders are ready: windows/ and shared/'
