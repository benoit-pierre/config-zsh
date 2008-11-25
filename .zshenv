
# Profiling.
# zmodload zsh/zprof

umask 077

# Utility functions. {{{

# Logging with timestamp in $ZDOTDIR/log (if $ZDOTDIR/debug exists).
zlog()
{
  if [[ -r "$ZDOTDIR/debug" ]]
  then
    echo "$(date --rfc-3339=sec) $@" >> "$ZDOTDIR/log"
  fi
}

# Will prepend $1 to path only if not already present.
zpath()
{
  if [[ -z "${path[(r)$1]}" ]]
  then
    export PATH="$1:$PATH"
    zlog "export PATH=${PATH}"
  fi
}

# Export $1=$2 if not already set.
zexport()
{
  eval "if [[ -z \"\$$1\" ]]; then export $1=\"$2\"; zlog \"export $1=$2\"; fi"
}

# Load and execute a function.
zload()
{
  if autoload -U "$1"
  then
    "$1"
  fi
}

# }}}

# Set ZDOTDIR if it wasn't already.
zexport ZDOTDIR "$HOME/.zsh"

zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# Path. {{{

zpath "$HOME/progs/bin"

# }}}

# Recompile ~/.zshenv if needed. {{{

f="$HOME/.zshenv"
if [[ -r "$f" ]] && [[ ! "$f.zwc" -nt "$f" ]]
then
  zcompile "$f"
fi

# }}}

# Readline. {{{

export INPUTRC="$HOME/.readline/inputrc"

# }}}

# Screen. {{{

export SCREENRC="$HOME/.screen/rc"

# }}}

# Grep. {{{

export GREP_OPTIONS='--color'

# }}}

# Man. {{{

export MANPAGER='pager --man'

# }}

# Python. {{{

if [[ -n =python(:q) ]]
then
  export PYTHONPATH="$HOME/progs/lib/python$(python -V |& cut -b 8-10)/site-packages${PYTHONPATH:+:$PYTHONPATH}"
fi

# }}}

# Ruby. {{{

if [[ -n =ruby(:q) ]]
then
  rubylib="$HOME/progs/lib/ruby"
  rubysite="$rubylib/site_ruby/`ruby -r rbconfig -e 'print Config::CONFIG["ruby_version"]'`"
  rubysitearch="$rubysite/`ruby -r rbconfig -e 'print Config::CONFIG["arch"]'`"
  export RUBYLIB="$rubysitearch:$rubysite:$rubylib${RUBYLIB:+:$RUBYLIB}"
fi

# }}}

# vim: fdm=marker
