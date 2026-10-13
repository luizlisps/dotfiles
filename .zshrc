# 1. Base environment
typeset -U path
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
# Keep Homebrew ahead of macOS system tools on Apple Silicon.
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

export EDITOR="nvim"


export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# 2. Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
DISABLE_AUTO_UPDATE="true"
plugins=(
  git
  history-substring-search
  vi-mode
  docker
  docker-compose
  nvm
  npm
  node
  bun
  uv
  macos
  zoxide
  fzf
)

export NVM_DIR="$HOME/.nvm"
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' silent-autoload yes

source "$ZSH/oh-my-zsh.sh"

# 3. History and completion
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border'

# 4. Command feedback
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6b7280'
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting must be loaded after other Zsh plugins.
if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 5. Starship prompt
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#93a1a1'
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# Show the vi-mode state before the folder; zle-keymap-select redraws it.
__vi_mode_label() {
  case $KEYMAP in
    vicmd) print -n '%B%K{#b58900}%F{#fdf6e3}[NORMAL]%f%k%b ' ;;
  esac
}
PROMPT=$'\n''$(__vi_mode_label)'"$PROMPT"

# 6. Aliases and helpers
# Git commands drop the "git"; other aliases only exist when used often.
alias vim='nvim'
alias add='git add'
alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias clone='git clone'
alias dots='git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME"'
alias ls='eza'
alias ll='eza -lah'
alias sail='./vendor/bin/sail'

mkcd() {
  if [ $# -ne 1 ]; then
    echo 'uso: mkcd diretorio'
    return 2
  fi

  mkdir -p -- "$1" && cd -- "$1"
}

# Open Yazi and stay in the directory it was in when quitting.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd -- "$cwd"
  rm -f -- "$tmp"
}

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
export PATH=/opt/homebrew/opt/openjdk@25/bin:$PATH
