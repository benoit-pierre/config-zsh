
zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# Setup fpath. {{{

fpath=("$ZDOTDIR/functions" $fpath)

# }}}

# Recompile outdated .zwc's. {{{

autoload recompile_zdots && recompile_zdots
autoload recompile_functions && recompile_functions

# }}}

# Command line. {{{

# Setup key mapping.
autoload load_kbd set_kbd &&
if ! load_kbd
then
  set_kbd
fi

# Quick binding to kill current job.
bindkey '\egl' get-line
bindkey '\epl' push-line
bindkey '\epi' push-input
bindkey -s '^k' '\epl\epikill -9\ %%\n\egl'

# Allow comments inside command line.
setopt INTERACTIVE_COMMENTS

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
alias f='find'
alias g='grep'
alias h='head'
alias ll='less'
alias t='tail'
alias wl='wc -l'
alias x='xargs'
alias x0='xargs -0'
alias -g G='|grep'
alias -g H='|head'
alias -g L='|less'
alias -g S='|sort'
alias -g T='|tail'
alias -g WL='|wc -l'
alias -g X='|xargs'
alias -g X0='|xargs -0'
alias -g FX0='-print0|xargs -0'

# }}}

# Useful functions. {{{

# launch make inside VIM
vmake()
{
  cmd="VMake"
  for arg in "$@"
  do
    cmd+=" $arg:q"
  done
  vim +"$cmd"
}

# }}}

# Expansion and globbing. {{{

# Don't expand globs in place, but generate a completion list.
setopt GLOB_COMPLETE

# Expand word{21daz} like word{1,2,a,d,z} to:
# word1 word2 worda wordd wordz
setopt BRACE_CCL

# }}}

# Completion. {{{

# Enter menu after second key press.
setopt AUTO_MENU

# More compact layout, auto list on ambiguous completion (even when something
# was inserted).
setopt LIST_PACKED
setopt AUTO_LIST
setopt NO_LIST_AMBIGUOUS
export LISTMAX=0

# Colorize completion list.
zstyle ':completion:*' list-colors ''

# Caching.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/cache"

# Ignore functions for unsupported commands.
zstyle ':completion:*:functions' ignored-patterns '_*'

# Better messages.
zstyle ':completion:*' select-prompt %Scurrent selection at %p%s
zstyle ':completion:*:warnings' format 'no matches for: %d%b'
zstyle ':completion:*' list-prompt '%Sat %p%s'
zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' format '%d'

# Use menu mode.
zstyle ':completion:*' menu select=1

# Add all matches to completion list, try regular completion, then from both
# end, and finally try correction.
zstyle ':completion:*' completer _expand _complete _complete:bothends _correct
zstyle ':completion:*:bothends:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'

# Prevent CVS files/directories from being completed.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Don't use old system.
zstyle ':completion:*' use-compctl false

# Don't be verbose.
zstyle ':completion:*' verbose false

# Except when completing for the cd builtin (needed for completion usable
# completion off "cd ±x").
zstyle ':completion:*:*:cd:*' verbose true

# Complete process IDs with menu selection and be verbose.
zstyle ':completion:*:*:kill:*' verbose true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Sort files by name.
zstyle ':completion:*' file-sort name

# Avoid completing current directory in some cases.
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' ignore-parents parent pwd ..

# More information for options.
zstyle ':completion:*' list-suffixes true

# }}}

# Other ZSH options. {{{

# Enable expansion after an =.
setopt MAGIC_EQUAL_SUBST

# Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Allow a ' inside '' by doubling it.
setopt RC_QUOTES

# }}}

# Prompt. {{{ 

# Activate expansion inside prompt.
setopt PROMPT_SUBST

# Start prompt system.
autoload promptinit && promptinit

# Prompt theme.
prompt bpierre

# }}}

if [[ -r "$ZDOTDIR/profile" ]]
then
  zprof
fi

# vim: fdm=marker
