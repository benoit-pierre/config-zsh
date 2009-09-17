
zlog "source $(print -P %N)${TTY:+ [$TTY]}"

# SSH/GPG agents. {{{

autoload ssh-gpg-agents && ssh-gpg-agents

# }}}

# vim: fdm=marker
