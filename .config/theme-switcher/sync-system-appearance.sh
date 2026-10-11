#!/bin/zsh
set -eu

mode=light
if /usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null | /usr/bin/grep -q 'Dark'; then
  mode=dark
fi

cache_dir="$HOME/.cache"
state_file="$cache_dir/system-appearance-theme"
mkdir -p "$cache_dir"

previous_mode=''
if [[ -r "$state_file" ]]; then
  previous_mode="$(<"$state_file")"
fi
if [[ "$previous_mode" == "$mode" ]]; then
  exit 0
fi

tmp_file="$state_file.$$"
print -r -- "$mode" > "$tmp_file"
mv "$tmp_file" "$state_file"

tmux_bin=''
for candidate in /opt/homebrew/bin/tmux /usr/local/bin/tmux; do
  if [[ -x "$candidate" ]]; then
    tmux_bin="$candidate"
    break
  fi
done
if [[ -z "$tmux_bin" ]] && command -v tmux >/dev/null 2>&1; then
  tmux_bin="$(command -v tmux)"
fi

if [[ -n "$tmux_bin" ]] && "$tmux_bin" has-session 2>/dev/null; then
  "$tmux_bin" source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
  while IFS= read -r client; do
    "$tmux_bin" refresh-client -S -t "$client" >/dev/null 2>&1 || true
  done < <("$tmux_bin" list-clients -F '#{client_name}')
fi

hermes_bin="$HOME/.local/bin/hermes"
if [[ -x "$hermes_bin" ]]; then
  "$hermes_bin" config set display.skin "web-$mode" >/dev/null 2>&1 || true
fi
