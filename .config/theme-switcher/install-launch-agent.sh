#!/usr/bin/env bash
set -euo pipefail

label='com.luizgustavo.system-theme-sync'
agent="$HOME/Library/LaunchAgents/$label.plist"
sync_script="$HOME/.config/theme-switcher/sync-system-appearance.sh"
service="gui/$(id -u)/$label"

if [[ "${1:-}" == '--dry-run' ]]; then
  printf 'would install %s and load %s\n' "$agent" "$service"
  exit 0
fi

[[ $# -eq 0 ]] || { printf 'usage: %s [--dry-run]\n' "$0" >&2; exit 2; }
[[ -x "$sync_script" ]] || { printf 'missing theme sync script: %s\n' "$sync_script" >&2; exit 1; }

mkdir -p -- "$(dirname -- "$agent")"
tmp="$(mktemp -t dotfiles-theme-agent.XXXXXX)"
trap 'rm -f -- "$tmp"' EXIT

cat > "$tmp" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>$sync_script</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$HOME/Library/Preferences/.GlobalPreferences.plist</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
PLIST

plutil -lint -s "$tmp"

if [[ -f "$agent" ]] && cmp -s "$tmp" "$agent"; then
  if launchctl print "$service" >/dev/null 2>&1; then
    printf 'theme sync agent already installed and loaded\n'
    exit 0
  fi
else
  if [[ -e "$agent" ]]; then
    backup="$agent.backup.$(date +%Y%m%d-%H%M%S)"
    cp -p -- "$agent" "$backup"
    printf 'backed up previous agent to %s\n' "$backup"
  fi
  install -m 644 "$tmp" "$agent"
fi

if launchctl print "gui/$(id -u)" >/dev/null 2>&1; then
  if launchctl print "$service" >/dev/null 2>&1; then
    launchctl bootout "$service"
  fi
  launchctl bootstrap "gui/$(id -u)" "$agent"
  printf 'theme sync agent loaded: %s\n' "$service"
else
  printf 'theme sync agent installed; it will load at the next GUI login\n'
fi
