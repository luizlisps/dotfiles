# ~/.zshrc -- interactive shells only. Login PATH lives in ~/.zprofile / ~/.zshenv.

# 1. Environment
typeset -U path fpath                       # no duplicate PATH/fpath entries
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
path=($HOME/.local/bin $path)

# Homebrew completions (starship, eza, ...) must be on fpath before compinit.
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Theme data (LS_COLORS, fzf, highlighting, suggestions): seoul256 default.
# Sourced before oh-my-zsh so plugins and completion styles pick it up.
source "$HOME/.config/zsh/seoul256.zsh"

# 2. Oh My Zsh
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
  zoxide                # z <dir>, zi
  fzf                   # keep last: Ctrl-R / Ctrl-T / Alt-C override vi-mode's
)

source "$ZSH/oh-my-zsh.sh"

# 3. Shell behaviour
KEYTIMEOUT=1                                # vi-mode: Esc takes effect after 10ms, not 400ms
setopt AUTO_CD                              # `dir` == `cd dir`
setopt INTERACTIVE_COMMENTS                 # allow # comments at the prompt
setopt NO_BEEP

# 4. History
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
setopt HIST_VERIFY                          # !! expands in the buffer, no blind run

# 5. Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#bdbdbd}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#ffbfbd}no matches for: %d%f'

# 6. Keys: Up/Down (and k/j in vi command mode) search history for what is typed.
for _k in '^[[A' '^[OA'; do bindkey $_k history-substring-search-up;   bindkey -M viins $_k history-substring-search-up;   done
for _k in '^[[B' '^[OB'; do bindkey $_k history-substring-search-down; bindkey -M viins $_k history-substring-search-down; done
unset _k
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# 7. Prompt (pure preset: ~/.config/starship.toml)
eval "$(starship init zsh)"

# 8. Command feedback (brew plugins; highlighting must load last)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
