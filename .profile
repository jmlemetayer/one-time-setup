# ~/.profile

# Set the default umask
umask 0022

# Saved .shrc in ENV if it exists
[ -f "${HOME}/.shrc" ] && export ENV="${HOME}/.shrc"

# Include .bashrc if it exists and if running bash
[ -n "${BASH}" ] && [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"

# GPG
export GPG_TTY=$(tty)
gpg-connect-agent /bye
gpg-connect-agent updatestartuptty /bye
export SSH_AUTH_SOCK=$(gpg-connect-agent 'getinfo ssh_socket_name' /bye | awk '/D/{print$2}')
