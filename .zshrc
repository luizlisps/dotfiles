# 1. Base environment
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
__set_starship_theme() {
  local variant='light'
  local autosuggest_style='fg=#5b616e'

  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    variant='dark'
    autosuggest_style='fg=#b4b4b4'
  fi

  export STARSHIP_CONFIG="$HOME/.config/theme-switcher/themes/web/starship-$variant.toml"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="$autosuggest_style"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __set_starship_theme
__set_starship_theme
eval "$(starship init zsh)"

__hermes_skin() {
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    print -r -- "web-dark"
  else
    print -r -- "web-light"
  fi
}

hermes() {
  local skin="$(__hermes_skin)"
  local current

  current="$(command hermes config get display.skin 2>/dev/null)"
  if [[ "$current" != "$skin" ]]; then
    command hermes config set display.skin "$skin" >/dev/null 2>&1
  fi

  command hermes "$@"
}

# 6. Aliases and helpers
alias vim='nvim'
alias push='git push'
alias add='git add'
alias commit='git commit -m'
alias clone='git clone'
alias pull='git pull'
alias cls='clear'
alias ls='eza'
alias ll='eza -lah'
alias la='eza -A'
alias ..='cd ..'
alias dotfiles='git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME"'
alias dots='dotfiles'
alias fetch='fastfetch'
alias sail='./vendor/bin/sail'

mkcd() {
  if [ $# -ne 1 ]; then
    echo 'uso: mkcd diretorio'
    return 2
  fi

  mkdir -p -- "$1" && cd -- "$1"
}

force() {
  if [ $# -eq 0 ]; then
    echo 'uso: force "mensagem do commit"'
    return 2
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo 'force: nao esta dentro de um repositorio Git'
    return 1
  fi

  git add . && git commit -m "$*" && git push
}

vault_qmd() {
  (cd "$HOME/git/vault" && qmd "$@")
}



# pnpm
export PNPM_HOME='/Users/luizgustavo/Library/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
export PATH=/opt/homebrew/opt/openjdk@25/bin:$PATH
