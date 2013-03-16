
# Set ZDOTDIR if it wasn't already.
if [[ -z "$ZDOTDIR" ]]
then
  export ZDOTDIR="$HOME/.zsh"
fi

# Profiling.
if [[ -r "$ZDOTDIR/profile" ]]
then
  zmodload zsh/zprof
fi

# Setup fpath. {{{

fpath=("$ZDOTDIR/functions" $fpath)

# }}}

# Utility functions. {{{

# Logging with timestamp in $ZDOTDIR/log (if $ZDOTDIR/debug exists).
if [[ -r "$ZDOTDIR/debug" ]]
then
  zlog() { echo "$(date --rfc-3339=sec) [$$] $@" >> "$ZDOTDIR/log" }
  alias zlog-source='zlog "source $(print -P %x)${TTY:+ [$TTY]}"'
else
  zlog() {}
  alias zlog-source=''
fi

zlog-source

# Will prepend $1 to path (removing existing duplicates).
zpath()
{
  n="$1"
  shift
  eval "
  typeset -U np
  np=($@ \${(s|:|)$n})
  export $n=\"\${(j|:|)np}\"
"
}

# Export $1=$2 if not already set.
zexport()
{
  eval "if [[ -z \"\$$1\" ]]; then export $1=\"$2\"; zlog \"export $1=$2\"; fi"
}

# }}}

# Recompile ~/.zshenv if needed. {{{

f="$HOME/.zshenv"
if [[ -r "$f" && ! "$f.zwc" -nt "$f" ]]
then
  zcompile "$f"
fi

# }}}

# vim: fdm=marker
