
zlog "${TTY:+$TTY }$(print -P %N)"

zload()
{
  if autoload -U "$1"
  then
    "$1"
  fi
}

# History. {{{

export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=1000
export SAVEHIST=1000

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

# Load colors definition.
zload colors

# Prompt. {{{ 

setopt PROMPT_SUBST

# Colorize completion list.
export ZLS_COLOURS=''
autoload complist

if [[ "$TERM" != "dumb" ]]
then
  export PROMPT='%b%u%{$fg_no_bold[white]%}%~ %{%(?.$fg_no_bold[green].$fg_no_bold[red])%}%(?.>.!)%{$reset_color%} '
else
  export PROMPT='%~ %(?.>.!)%} '
fi

# }}}

# vim: fdm=marker
