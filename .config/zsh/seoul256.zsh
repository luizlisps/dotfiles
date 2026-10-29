# seoul256 dark (junegunn/seoul256.vim, default rgb_map, bg 237 / fg 252).
# Each role takes the colour the Vim scheme gives the matching group:
# Directory 187, Statement 108, Special 216, Type 179, Operator 186, ...
# Source this BEFORE oh-my-zsh, completion styles and the highlighting plugins.

# ls / completion lists
export LS_COLORS='di=38;2;223;222;189:ln=38;2;188;224;255:ex=38;2;188;221;189:so=38;2;255;189;152:pi=38;2;223;188;114:bd=38;2;223;188;114:cd=38;2;223;188;114:or=38;2;255;191;189:mi=38;2;255;191;189:su=38;2;255;191;189:sg=38;2;255;191;189:tw=38;2;223;222;189:ow=38;2;223;222;189:st=38;2;223;222;189'
export EZA_COLORS='uu=38;2;217;217;217:gu=38;2;217;217;217:un=38;2;189;189;189:gn=38;2;189;189;189:sn=38;2;217;217;217:sb=38;2;189;189;189:da=38;2;189;189;189:hd=4;38;2;189;189;189:lp=38;2;189;189;189:xx=38;2;189;189;189:ur=38;2;223;188;114:gr=38;2;223;188;114:tr=38;2;223;188;114:uw=38;2;225;120;153:gw=38;2;225;120;153:tw=38;2;225;120;153:ux=38;2;152;188;153:ue=38;2;152;188;153:gx=38;2;152;188;153:tx=38;2;152;188;153:ga=38;2;188;221;189:gm=38;2;188;224;255:gd=38;2;255;191;189:gv=38;2;224;190;188:gt=38;2;255;192;222'

# fzf
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --color=fg:#d9d9d9,bg:#4b4b4b,hl:#bcddbd,fg+:#f1f1f1,bg+:#616161,hl+:#bce0ff,info:#bcddbd,prompt:#bcdede,pointer:#ffc0de,marker:#ffc0de,spinner:#bcddbd,header:#bdbdbd,border:#999872'

# zsh-autosuggestions: NonText
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#bdbdbd'

# history-substring-search: Visual for a match, Error for no match
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#007173,fg=#f1f1f1'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#730b00,fg=#d9d9d9'

# zsh-syntax-highlighting reads these at highlight time.
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
