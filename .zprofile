
zlog-source

# Base configuration. {{{

# XDG config directory. {{{

# Simplify the rest of the code by setting XDG_CONFIG_HOME.
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# }}}

# Path. {{{

vimbin="$XDG_CONFIG_HOME/vim/bin"
if [[ -d "$vimbin" ]]
then
  zpath PATH "$vimbin"
fi

zpath PATH "$HOME/progs"/{sbin,bin}

zpath PATH "$HOME/.local/bin"

# }}}

# Make sure environment directory exists. {{{

mkdir -p "$ZDOTDIR/env"

# }}}

# Library path. {{{

zpath LD_LIBRARY_PATH "$HOME/progs/lib"

# }}}

# }}}

# Editor/Pager. {{{

export EDITOR='vim'

for candidate in vimpager less more
do
  pager="`which $candidate 2>/dev/null`"
  if [[ -n "$pager" ]]
  then
    export PAGER='vimpager'
    break
  fi
done
if [[ 'less' = "$PAGER" ]]
then
  export LESS='-F -X'
fi
if [[ 'vimpager' = "$PAGER" ]]
then
  export VLESS_OPT='-F -X'
fi

# }}}

# Info. {{{

zpath INFOPATH "$HOME/progs/share/info"

# }}}

# Man. {{{

if [[ 'vimpager' = "$PAGER" ]]
then
  export MANPAGER="$PAGER --man"
fi

typeset -U manpath
manpath=("$HOME/progs/share/man" ${(s|:|)$(manpath -q)})
export MANPATH="${(j|:|)manpath}"

# }}}

# pkg-config. {{{

zpath PKG_CONFIG_PATH "$HOME/progs/lib/pkgconfig"

# }}}

# Python. {{{

# Force encoding to UTF-8.
export PYTHONIOENCODING='UTF-8'

# }}}

# Readline. {{{

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

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
      rubyver="`ruby -r rbconfig -e 'print RbConfig::CONFIG["ruby_version"]'`"
      rubyarch="`ruby -r rbconfig -e 'print RbConfig::CONFIG["arch"]'`"
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

# Screen. {{{

export SCREENRC="$XDG_CONFIG_HOME/screen/rc"

# }}}

# Sup. {{{

# Switch to Xapian index.
export SUP_INDEX=xapian

# }}}

# vim: fdm=marker foldlevel=0
