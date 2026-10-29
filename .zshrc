# ~/.zshrc -- interactive shells only. Login PATH lives in ~/.zprofile / ~/.zshenv.

# 1. Environment
typeset -U path fpath                       # no duplicate PATH/fpath entries
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
path=($HOME/.local/bin $path)

if (( $+commands[nvim] )); then export EDITOR=nvim; else export EDITOR=vim; fi
export VISUAL=$EDITOR
export LESS='-FRX --mouse'                  # quit if one screen, keep colours, no clear
export CLICOLOR=1

# Homebrew completions (starship, eza, ...) must be on fpath before compinit.
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# 2. Theme data (LS_COLORS, fzf, highlighting, suggestions): seoul256 default
source "$HOME/.config/zsh/seoul256.zsh"

# 3. Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                                # prompt comes from starship
zstyle ':omz:update' mode disabled          # update by hand: omz update
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
[[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

plugins=(
  git
  vi-mode
  history-substring-search
  sudo                  # Esc Esc: prefix the line with sudo
  extract               # x <archive>
  copypath              # copy the cwd to the clipboard
  colored-man-pages
  macos
  docker
  docker-compose
  nvm
  npm
  node
  bun
  uv
  zoxide                # z <dir>, zi
  fzf                   # keep last: Ctrl-R / Ctrl-T / Alt-C override vi-mode's
)

export NVM_DIR="$HOME/.nvm"
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' silent-autoload yes

source "$ZSH/oh-my-zsh.sh"

# 4. Shell behaviour
KEYTIMEOUT=1                                # vi-mode: Esc takes effect after 10ms, not 400ms
WORDCHARS=${WORDCHARS//[\/.-]/}             # Ctrl-W stops at / . -
setopt AUTO_CD                              # `dir` == `cd dir`
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt INTERACTIVE_COMMENTS                 # allow # comments at the prompt
setopt NO_BEEP
setopt COMPLETE_IN_WORD ALWAYS_TO_END

# 5. History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY                     # timestamps
setopt SHARE_HISTORY                        # live-share across sessions
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE                    # a leading space keeps a command out of history
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY                          # !! expands in the buffer, no blind run

# 6. Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#bdbdbd}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#ffbfbd}no matches for: %d%f'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# 7. Keys
# Up/Down search history for what is already typed (both keymaps, both escape styles).
for _k in '^[[A' '^[OA'; do bindkey $_k history-substring-search-up;   bindkey -M viins $_k history-substring-search-up;   done
for _k in '^[[B' '^[OB'; do bindkey $_k history-substring-search-down; bindkey -M viins $_k history-substring-search-down; done
unset _k
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[1;3D' backward-word             # Alt-Left
bindkey '^[[1;3C' forward-word              # Alt-Right
bindkey '^[[3~'   delete-char               # Delete

# 8. Command feedback (brew plugins; highlighting must load last)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 9. Prompt (pure preset: ~/.config/starship.toml)
eval "$(starship init zsh)"

# 10. Aliases and helpers
alias ls='eza'
alias ll='eza -lah --git'
alias la='eza -a'
alias lt='eza --tree --level=2'
alias ..='cd ..'
alias ...='cd ../..'

mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Open Yazi and cd into the directory it was in when quitting.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  [[ -n $cwd && $cwd != $PWD ]] && cd -- "$cwd"
  rm -f -- "$tmp"
}
