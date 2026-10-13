[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Keep lazygit config with the other dotfiles instead of ~/Library.
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
