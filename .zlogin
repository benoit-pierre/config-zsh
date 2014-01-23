
zlog-source

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

unset \
  LANG \
  LANGUAGE \
  LC_ADDRESS \
  LC_ALL \
  LC_COLLATE \
  LC_CTYPE \
  LC_IDENTIFICATION \
  LC_MEASUREMENT \
  LC_MESSAGES \
  LC_MONETARY \
  LC_NAME \
  LC_NUMERIC \
  LC_PAPER \
  LC_TELEPHONE \
  LC_TIME \

export LC_ALL='en_US.UTF-8'

# }}}

# SSH/GPG agents. {{{

autoload ssh-gpg-agents
# Do not automatically start agents when login from ssh.
if [[ 0 -eq $? && -z "$SSH_CONNECTION" ]]
then
  ssh-gpg-agents
fi

# }}}

# BZR shell-completer. {{{

export BZR_SHELL_COMPLETER="$ZDOTDIR/functions/_bzr"

# }}}

# vim: fdm=marker
