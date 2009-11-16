
zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# umask/ulimit. {{{

umask 077

ulimit -s unlimited  # stack size (kbytes)
ulimit -c 0          # core file size (blocks)
ulimit -m unlimited  # resident set size (kbytes)
ulimit -u unlimited  # processe
ulimit -n unlimited  # file descriptors  (1024 ?)
ulimit -l unlimited  # locked-in-memory size (kb)
ulimit -v unlimited  # address space (kb)
ulimit -x unlimited  # file locks

# }}}

# Locale. {{{

export LC_ALL='en_US.UTF-8'

# }}}

# Path. {{{

zpath PATH "$HOME/progs"/{sbin,bin}

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

# Sup. {{{

# Switch to Xapian index.
export SUP_INDEX=xapian

# }}}

# SSH/GPG agents. {{{

autoload ssh-gpg-agents && ssh-gpg-agents

# }}}

# BZR shell-completer. {{{

export BZR_SHELL_COMPLETER="$ZDOTDIR/functions/_bzr"

# }}}

# vim: fdm=marker
