
zlog-source

# Recompile outdated .zwc's. {{{

autoload recompile_zdots && recompile_zdots
autoload recompile_functions && recompile_functions

# }}}

# Command line. {{{

# Faster escape...
export KEYTIMEOUT=1

# Clean up mappings.
bindkey -d

# Setup key mapping.
autoload loadkbd setkbd &&
if ! loadkbd
then
  setkbd
fi

# Quick binding to kill current job.
bindkey '\egl' get-line
bindkey '\epl' push-line
bindkey '\epi' push-input
bindkey -s '^k' '\epl\epikill -9\ %%\n\egl'

# Allow comments inside command line.
setopt INTERACTIVE_COMMENTS

# Do not beep on error.
setopt NO_BEEP

# Support for editing the current command line in VIM.
autoload -z vim-edit-command-line
zle -N vim-edit-command-line

# Support for executing the current command line and editing the output as a
# new command line in VIM.
autoload -z vim-edit-command-output
zle -N vim-edit-command-output

# Support for executing a VIM command on the edit buffer.
autoload -z vim-execute-command
zle -N vim-execute-command

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
alias l='ls -lh' lr='l -R' la='l -a' lt='l -rt' lar='l -AR' lS='l -rS'

# make
alias am='acoc make'
alias amd='am DVD_DEPENDS=yes'
alias m='make'
alias md='m DVD_DEPENDS=yes'

# rsync
alias rscp='rsync --partial --progress --rsh=ssh'

# process
alias k='kill'
alias k9='kill -9'
alias pk='pkill'
alias pk9='pkill -9'
alias pg='pgrep'

# man in gvim
if [[ "$MANPAGER" =~ '^vimpager\>' ]]
then
  alias gman="MANPAGER='$MANPAGER -g' man"
fi

alias bs='bzr shell'
alias d='du -xhc --max-depth=1 --exclude="./.?*"'
alias f='find'
alias g='grep'
alias h='head'
alias ll='less'
alias mi='mv -vi'
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

# Launch make inside VIM.
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

# Enable extending globbing.
setopt EXTENDED_GLOB

# }}}

# Colors. {{{

eval $(dircolors -b)

autoload colors && colors

# }}}

# Completion. {{{

# Initialize completion system.
autoload -U compinit && compinit

# Enter menu after second key press.
setopt AUTO_MENU

# More compact layout, auto list on ambiguous completion (even when something
# was inserted).
setopt LIST_PACKED
setopt AUTO_LIST
setopt NO_LIST_AMBIGUOUS
export LISTMAX=0

# No beep on ambigous completion.
setopt NO_LIST_BEEP

# Load completion list module.
zmodload zsh/complist

# Colorize completion list.
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-colors "$LS_COLORS"

# Group completion list by category.
zstyle ':completion:*' group-name ''

# Caching.
mkdir -p "$ZDOTDIR/cache"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/cache"

# Ignore functions for unsupported commands.
zstyle ':completion:*:functions' ignored-patterns '_*'

# Better messages.
zstyle ':completion:*' select-prompt %Scurrent selection at %p%s
zstyle ':completion:*:warnings' format 'no matches for: %d%b'
zstyle ':completion:*' list-prompt '%Sat %p%s'
zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' format "${bold_color}%d:${reset_color}"

# Use menu mode.
zstyle ':completion:*' menu select=1

# Easy selection of more than one entry during menu completion.
bindkey -M menuselect '[2~' accept-and-hold

# Add all matches to completion list, try regular completion, then from both
# end, and finally try correction.
zstyle ':completion:*' completer _expand _complete _complete:bothends _correct
zstyle ':completion:*:bothends:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'

# Prevent CVS files/directories from being completed.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Don't use old system.
zstyle ':completion:*' use-compctl false

# Be verbose.
zstyle ':completion:*' verbose true

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

# Don't complete "system" users (low UID + nobody) for SSH/SCP/rsync.
iusers="$ZDOTDIR/cache/ignored-users"
if [[ ! -f "$iusers" ]]
then
  getent passwd | sed -n '/^[^:]\+:[x*]:\([0-9]\{4,\}:\)\{2\}/!{s/^\([^:]\+\):.*/\1/p}' > "$iusers"
fi
zstyle ':completion:*:(ssh|scp|rsync):*:users' ignored-patterns nobody $(<"$iusers")

# Split man pages by section.
zstyle ':completion:*:man:*' separate-sections true

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

# Disable mail check feature.
export MAILCHECK=0

# }}}

# Prompt. {{{

# Activate expansion inside prompt.
setopt PROMPT_SUBST

# Start prompt system.
autoload promptinit && promptinit

# Prompt theme.
prompt bpierre

# }}}

# SSH/GPG agents. {{{

ssh-gpg-agents

# }}}

if [[ -r "$ZDOTDIR/profile" ]]
then
  zprof
fi

# vim: fdm=marker
