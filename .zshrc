
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
setopt HIST_SAVE_NO_DUPS
# Don't save command starting with a space.
setopt HIST_IGNORE_SPACE
# Clean commands before saving them.
setopt HIST_REDUCE_BLANKS
# Incrementally append to history (don't wait for logout).
setopt INC_APPEND_HISTORY

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

# Don't expand globs in place, but generate a completion list.
setopt GLOB_COMPLETE

# Enter menu after second key press.
setopt AUTO_MENU

# More compact layout, auto list on ambiguous completion (even when something
# was inserted).
setopt LIST_PACKED
setopt AUTO_LIST
setopt NO_LIST_AMBIGUOUS
export LISTMAX=0

# Colorize completion list.
zstyle ':completion:*:default' list-colors ''

# Caching.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/cache"

# Ignore functions for unsupported commands.
zstyle ':completion:*:functions' ignored-patterns '_*'

# Better messages.
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Better menu mode: auto select, interactive.
zstyle ':completion:*' menu auto select interactive

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
