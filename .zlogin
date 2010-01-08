
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

# SSH/GPG agents. {{{

autoload ssh-gpg-agents && ssh-gpg-agents

# }}}

# BZR shell-completer. {{{

export BZR_SHELL_COMPLETER="$ZDOTDIR/functions/_bzr"

# }}}

# vim: fdm=marker
