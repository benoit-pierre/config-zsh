
# Profiling.
# zmodload zsh/zprof

umask 077

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

# Locale. {{{

export LC_ALL='en_US.UTF-8'

# }}}

# Path. {{{

zpath PATH "$HOME/progs"/{sbin,bin}

# }}}

# Library path. {{{

zpath LD_LIBRARY_PATH "$HOME/progs/lib"

# }}}

# Recompile ~/.zshenv if needed. {{{

f="$HOME/.zshenv"
if [[ -r "$f" && ! "$f.zwc" -nt "$f" ]]
then
  zcompile "$f"
fi

# }}}

# Editor. {{{

export EDITOR='vim'

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

typeset -U manpath
manpath=("$HOME/progs/share/man" ${(s|:|)$(manpath -q)})
export MANPATH="${(j|:|)manpath}"

# }}

# Info. {{{

zpath INFOPATH "$HOME/progs/share/info"

# }}

# pkg-config. {{{

zpath PKG_CONFIG_PATH "$HOME/progs/lib/pkgconfig"

# }}}

# Python. {{{

python==python

if [[ -n "$python" ]]
then
  pythonenv="$ZDOTDIR/env/python"
  if [[ ! -r "$pythonenv" || "$pythonenv" -ot "$python" ]]
  then
    pythonlib="$HOME/progs/lib/python$(python -V |& cut -b 8-10)/site-packages"

    {
      echo pythonlib=\'$pythonlib\'

    } > "$pythonenv"

    zcompile "$pythonenv"

  fi

  . "$pythonenv"

  zpath PYTHONPATH "$pythonlib"
fi

# }}}

# Ruby. {{{

ruby==ruby

if [[ -n "$ruby" ]]
then
  rubyenv="$ZDOTDIR/env/ruby"
  if [[ ! -r "$rubyenv" || "$rubyenv" -ot "$ruby" ]]
  then
    rubylib="$HOME/progs/lib/ruby"
    rubysite="$rubylib/site_ruby/`ruby -r rbconfig -e 'print Config::CONFIG["ruby_version"]'`"
    rubysitearch="$rubysite/`ruby -r rbconfig -e 'print Config::CONFIG["arch"]'`"
    rubygems="/var/lib/gems/`ruby -r rbconfig -e 'print Config::CONFIG["ruby_version"]'`"

    {
      echo rubylib=\'$rubylib\'
      echo rubysite=\'$rubysite\'
      echo rubysitearch=\'$rubysitearch\'
      echo rubygems=\'$rubygems\'

    } > "$rubyenv"

    zcompile "$rubyenv"

  fi

  . "$rubyenv"

  zpath RUBYLIB "$rubysitearch" "$rubysite" "$rubylib"
  zpath PATH "$rubygems/bin"
  export RUBYOPT=rubygems
fi

# }}}

# vim: fdm=marker
