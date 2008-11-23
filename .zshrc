
zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# Setup fpath. {{{

fpath=("$ZDOTDIR/functions.zwc" "$ZDOTDIR/functions" $fpath)

# }}}

# Recompile outdated .zwc's. {{{

zload recompile_zdots
zload recompile_functions

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

# process
alias k='kill'
alias k9='kill -9'
alias pk='pkill'
alias pk9='pkill -9'
alias pg='pgrep'

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

# Other ZSH options. {{{

# Enable expansion after an =.
setopt MAGIC_EQUAL_SUBST

# }}}

# Prompt. {{{ 

# Activate expansion inside prompt.
setopt PROMPT_SUBST

zload promptinit
prompt bpierre

# }}}

# vim: fdm=marker
