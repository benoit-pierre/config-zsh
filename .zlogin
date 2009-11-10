
zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# Locale. {{{

export LC_ALL='en_US.UTF-8'

# }}}

# SSH/GPG agents. {{{

autoload ssh-gpg-agents && ssh-gpg-agents

# }}}

# vim: fdm=marker
