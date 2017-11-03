# ~/.profile

# Set the default umask
umask 0022

# Saved .shrc in ENV if it exists
[ -f "${HOME}/.shrc" ] && export ENV="${HOME}/.shrc"

# Include .bashrc if it exists and if running bash
[ -n "${BASH}" ] && [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
