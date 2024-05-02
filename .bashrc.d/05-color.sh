# Enable colorization for some commands.
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# Customized the ls(1) colors.
if [ -x "$(which dircolors)" ]; then
	if [ -f "${HOME}/.dircolors" ]; then
		eval "$(dircolors "${HOME}/.dircolors")"
	else
		eval "$(dircolors --bourne-shell)"
	fi
fi
