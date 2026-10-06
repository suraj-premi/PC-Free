#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

printf '1/5 Shell syntax…\n'
bash -n "$ROOT/pcfree" "$ROOT/scripts/init-env.sh" "$ROOT/.devcontainer/initialize.sh"

printf '2/5 Dev Container JSON…\n'
python3 -m json.tool "$ROOT/.devcontainer/devcontainer.json" >/dev/null

printf '3/5 Secret generation…\n'
mkdir -p "$TMP/project/scripts"
cp "$ROOT/.env.example" "$TMP/project/.env.example"
cp "$ROOT/scripts/init-env.sh" "$TMP/project/scripts/init-env.sh"
PCFREE_ENV_FILE="$TMP/project/.env" bash "$TMP/project/scripts/init-env.sh" >/dev/null
[ "$(stat -c '%a' "$TMP/project/.env")" = '600' ]
grep -q '^WINDOWS_USERNAME=PCFree$' "$TMP/project/.env"
if grep -q '^WINDOWS_PASSWORD=change-me$' "$TMP/project/.env"; then
  printf 'Generated password was not replaced.\n' >&2
  exit 1
fi
password="$(awk -F= '$1 == "WINDOWS_PASSWORD" {print substr($0, index($0, "=") + 1)}' "$TMP/project/.env")"
(( ${#password} >= 12 ))

printf '4/5 Compose essentials…\n'
grep -q 'VERSION: "10"' "$ROOT/windows10.yml"
grep -q '/dev/kvm' "$ROOT/windows10.yml"
grep -q 'target: /storage' "$ROOT/windows10.yml"
grep -q '127.0.0.1' "$ROOT/.env.example"

printf '5/5 Docker Compose config…\n'
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  cp "$TMP/project/.env" "$TMP/project/compose.env"
  docker compose --env-file "$TMP/project/compose.env" -f "$ROOT/windows10.yml" config --quiet
else
  printf 'SKIP (Docker Compose is not installed in this environment)\n'
fi

printf 'All available setup checks passed.\n'
