
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

# Path. {{{

vimbin="$HOME/.vim/bin"
if [[ -d "$vimbin" ]]
then
  zpath PATH "$vimbin"
fi

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

pager="`which vimpager 2>/dev/null`"

if [[ -n "$pager" ]]
then
  export MANPAGER='vimpager --man'
fi

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

python="`which python`" || python=''

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

ruby="`which ruby`" || ruby=''

if [[ -n "$ruby" ]]
then
  rvmpath="$HOME/.rvm"
  rvmscripts="$rvmpath/scripts"
  if [[ -s "$rvmscripts/rvm" ]]
  then
    . "$rvmscripts/rvm"
    rvmcompl="$ZDOTDIR/functions/_rvm"
    [[ -e "$rvmcompl" ]] || ln -s "$rvmscripts/zsh/Completion/_rvm" "$rvmcompl"
  else
    gem="`which gem`" || gem=''

    rubyenv="$ZDOTDIR/env/ruby"

    if [[ ! -r "$rubyenv" || "$rubyenv" -ot "$ruby" || -n "$gem" && "$rubyenv" -ot "$gem" ]]
    then
      rubylib="$HOME/progs/lib/ruby"
      rubyver="`ruby -r rbconfig -e 'print Config::CONFIG["ruby_version"]'`"
      rubyarch="`ruby -r rbconfig -e 'print Config::CONFIG["arch"]'`"
      rubysite="$rubylib/site_ruby/$rubyver"
      rubysitearch="$rubysite/$rubyarch"

      if [[ -n "$gem" ]]
      then
	eval "`ruby -r rubygems <<'EOF'
path = Gem.path.collect { |p| p + '/bin' }
puts 'rubygemspath=(' + path.join(' ') + ')'
EOF
	`"
      else
	rubygempath=''
      fi

      {
	echo rubylib=\'$rubylib\'
	echo rubysite=\'$rubysite\'
	echo rubysitearch=\'$rubysitearch\'
	echo rubygemspath=\($rubygemspath\)

      } > "$rubyenv"

      zcompile "$rubyenv"

    fi

    . "$rubyenv"

    zpath RUBYLIB "$rubysitearch" "$rubysite" "$rubylib"

    if [[ -n "$rubygemspath" ]]
    then
      zpath PATH "$rubygemspath"
      export RUBYOPT=rubygems
    fi
  fi
fi

# }}}

# Sup. {{{

# Switch to Xapian index.
export SUP_INDEX=xapian

# }}}

# Xterm. {{{

if [[ -d "$HOME/progs/lib/terminfo" ]]
then
  export TERMINFO="$HOME/progs/lib/terminfo"
fi

# }}}

# vim: fdm=marker
