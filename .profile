# Set the default umask
umask 0027

# Include .bashrc if it exists and if running bash
[ -n "${BASH}" ] && [ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
