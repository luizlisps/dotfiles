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

# seoul256 dark (junegunn/seoul256.vim, default rgb_map, bg 237 / fg 252).
# Each role takes the colour the Vim scheme gives the matching group:
# Directory 187, Statement 108, Special 216, Type 179, Operator 186, etc.
export LS_COLORS='di=38;2;223;222;189:ln=38;2;188;224;255:ex=38;2;188;221;189:so=38;2;255;189;152:pi=38;2;223;188;114:bd=38;2;223;188;114:cd=38;2;223;188;114:or=38;2;255;191;189:mi=38;2;255;191;189:su=38;2;255;191;189:sg=38;2;255;191;189:tw=38;2;223;222;189:ow=38;2;223;222;189:st=38;2;223;222;189'
export EZA_COLORS='uu=38;2;217;217;217:gu=38;2;217;217;217:un=38;2;189;189;189:gn=38;2;189;189;189:sn=38;2;217;217;217:sb=38;2;189;189;189:da=38;2;189;189;189:hd=4;38;2;189;189;189:lp=38;2;189;189;189:xx=38;2;189;189;189:ur=38;2;223;188;114:gr=38;2;223;188;114:tr=38;2;223;188;114:uw=38;2;225;120;153:gw=38;2;225;120;153:tw=38;2;225;120;153:ux=38;2;152;188;153:ue=38;2;152;188;153:gx=38;2;152;188;153:tx=38;2;152;188;153:ga=38;2;188;221;189:gm=38;2;188;224;255:gd=38;2;255;191;189:gv=38;2;224;190;188:gt=38;2;255;192;222'

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --color=fg:#d9d9d9,bg:#4b4b4b,hl:#bcddbd,fg+:#f1f1f1,bg+:#616161,hl+:#bce0ff,info:#bcddbd,prompt:#bcdede,pointer:#ffc0de,marker:#ffc0de,spinner:#bcddbd,header:#bdbdbd,border:#999872'

# 4. Command feedback
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting reads these at highlight time; set before sourcing.
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
  default                        'fg=#d9d9d9'
  unknown-token                  'fg=#d9d9d9,bg=#730b00'
  reserved-word                  'fg=#e17899'
  alias                          'fg=#dfdebd'
  suffix-alias                   'fg=#dfdebd'
  global-alias                   'fg=#dfdebd'
  builtin                        'fg=#98bc99'
  function                       'fg=#dfdebd'
  command                        'fg=#dfdebd'
  precommand                     'fg=#e19972,underline'
  commandseparator               'fg=#dedd99'
  hashed-command                 'fg=#dfdebd'
  autodirectory                  'fg=#dfdebd,underline'
  path                           'fg=#dfdebd,underline'
  path_prefix                    'fg=#dfdebd,underline'
  globbing                       'fg=#ffbd98'
  history-expansion              'fg=#ffbd98'
  command-substitution           'none'
  command-substitution-delimiter 'fg=#be9873'
  process-substitution-delimiter 'fg=#be9873'
  single-hyphen-option           'fg=#dfbc72'
  double-hyphen-option           'fg=#dfbc72'
  back-quoted-argument           'fg=#ffbd98'
  back-quoted-argument-delimiter 'fg=#be9873'
  single-quoted-argument         'fg=#98bcbd'
  double-quoted-argument         'fg=#98bcbd'
  dollar-quoted-argument         'fg=#98bcbd'
  rc-quote                       'fg=#ffbd98'
  dollar-double-quoted-argument  'fg=#ffbd98'
  back-double-quoted-argument    'fg=#ffbd98'
  back-dollar-quoted-argument    'fg=#ffbd98'
  assign                         'fg=#6fbcbd'
  redirection                    'fg=#dedd99'
  comment                        'fg=#719872'
  named-fd                       'fg=#6fbcbd'
  numeric-fd                     'fg=#6fbcbd'
  arg0                           'fg=#dfdebd'
)

# Syntax highlighting must be loaded after other Zsh plugins.
if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 5. Starship prompt
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#bdbdbd'
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# Blank line above each prompt; the vi mode marker is starship's vimcmd_symbol.
PROMPT=$'\n'"$PROMPT"

# 6. Aliases and helpers
# Git commands drop the "git"; other aliases only exist when used often.
alias vim='nvim'
alias add='git add'
alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias clone='git clone'
alias dots='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
alias ls='eza'
alias ll='eza -lah'
alias sail='./vendor/bin/sail'
alias lg='lazygit'

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

# Tint the background while an interactive SSH session is open
# (per pane inside tmux, which would otherwise swallow the OSC 11)
ssh() {
  if [[ -t 1 ]]; then
    if [[ -n $TMUX ]]; then tmux select-pane -P 'bg=#333233'
    else printf '\e]11;#333233\a'; fi
  fi
  command ssh "$@"
  local ret=$?
  if [[ -t 1 ]]; then
    if [[ -n $TMUX ]]; then tmux select-pane -P 'bg=default'
    else printf '\e]111\a'; fi
  fi
  return $ret
}
