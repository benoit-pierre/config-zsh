
umask 077

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
    zlog "PATH: ${PATH}"
  fi
}

# Export $1=$2 if not already set.
zexport()
{
  eval "if [ -z \"$1\" ]; then export $1=\"$2\"; zlog \"$1: $2\"; fi"
}

# Set ZDOTDIR if it wasn't already.
zexport ZDOTDIR "$HOME/.zsh"

zlog "${TTY:+$TTY }$(print -P %N)"

# Path
if [[ -d "$HOME/progs/bin" ]]
then
  zpath "$HOME/progs/bin"
fi

# Readline.
export INPUTRC="$HOME/.readline/inputrc"

# Screen.
export SCREENRC="$HOME/.screen/rc"

# Grep.
export GREP_OPTIONS='--color'

# vim: foldmethod=marker
