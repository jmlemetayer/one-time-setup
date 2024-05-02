# Check the window size after each command.
shopt -s checkwinsize

# Enable the ** glob pattern.
shopt -s globstar

# Add user's private bin to PATH.
addtopath "${HOME}/.local/bin"
