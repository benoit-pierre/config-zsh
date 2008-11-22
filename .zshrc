
zlog "${TTY:+$TTY }$(print -P %N)"

# Utility functions. {{{

# Load and execute a function.
zload()
{
  if autoload -U "$1"
  then
    "$1"
  fi
}

# }}}

# History. {{{

export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=1000
export SAVEHIST=$HISTSIZE

# No dups (kill old).
setopt HIST_IGNORE_ALL_DUPS
# Don't save command starting with a space.
setopt HIST_IGNORE_SPACE
# Clean commands before saving them.
setopt HIST_REDUCE_BLANKS

# }}}

# Aliases. {{{

# ls
if [[ "$TERM" != "dumb" ]]
then
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh' lr='l -R' la='l -a' lt='l -t' lar='l -AR'

# make
alias am='acoc make'
alias amd='am DVD_DEPENDS=yes'
alias m='make'
alias md='m DVD_DEPENDS=yes'

alias bs='bzr shell'
alias d='du -xhc --max-depth=1 --exclude="./.?*"'
alias g='grep'
alias h='head'
alias ll='less'
alias t='tail'
alias wl='wc -l'
alias x0='xargs -0'
alias -g G='|grep'
alias -g H='|head'
alias -g L='|less'
alias -g S='|sort'
alias -g T='|tail'
alias -g WL='|wc -l'
alias -g X0='|xargs -0'

# }}}

# Completion. {{{

zload compinit

# Don't expand globs in place.
setopt GLOB_COMPLETE

# Enter menu after second key press.
setopt AUTO_MENU

# More compact layout.
setopt LIST_PACKED

# Colorize completion list.
autoload complist
zstyle ':completion:*:default' list-colors ''

# Caching.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/cache"

# Ignore functions for unsupported commands.
zstyle ':completion:*:functions' ignored-patterns '_*'

# }}}

# Prompt. {{{ 

# Load colors definition.
zload colors

# Activate expansion inside prompt.
setopt PROMPT_SUBST

if [[ "$TERM" != "dumb" ]]
then
  export PROMPT='%b%u%{$fg_no_bold[white]%}%~ %{%(?.$fg_no_bold[green].$fg_no_bold[red])%}%(?.>.!)%{$reset_color%} '
else
  export PROMPT='%~ %(?.>.!)%} '
fi

# }}}

# vim: fdm=marker
