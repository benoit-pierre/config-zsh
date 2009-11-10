
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
  zlog() { echo "$(date --rfc-3339=sec) $@" >> "$ZDOTDIR/log" }
else
  zlog() {}
fi

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

zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# Recompile ~/.zshenv if needed. {{{

f="$HOME/.zshenv"
if [[ -r "$f" && ! "$f.zwc" -nt "$f" ]]
then
  zcompile "$f"
fi

# }}}

# Library path. {{{

zpath LD_LIBRARY_PATH "$HOME/progs/lib"

# }}}

# vim: fdm=marker
