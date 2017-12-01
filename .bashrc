# If not running interactively, don't do anything.
[[ "${-}" != *i* ]] && return

#
# Color configuration.
#

# Customize the bash(1) prompt. Read the bash(1) PROMPTING paragraph for more
# info about the PS1 formatting. Check this URL for more info about ANSI escape
# codes: https://en.wikipedia.org/wiki/ANSI_escape_code
if [ "$(id --user)" = 0 ]
then
	PS1='\[\033[31m\]\u@\H\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ '
else
	PS1='\[\033[32m\]\u@\H\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ '
fi

# Enable colorization for some commands.
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# Customized the ls(1) colors.
if [ -x "$(which dircolors)" ]
then
	if [ -f "${HOME}/.dircolors" ]
	then
		eval $(dircolors "${HOME}/.dircolors")
	else
		eval $(dircolors --bourne-shell)
	fi
fi

#
# History configuration. Read the bash(1) HISTORY paragraph for more info.
#

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

#
# Aliases and functions definition.
#

# Basic aliases.
alias ll="ls --format=long"
alias la="ll --almost-all"
alias mkdir="mkdir --parents"

# Misunderstood aliases.
alias cd..="cd .."
alias l="ll"
alias mroe="more"
alias pdw="pwd"
alias tre="tree"

# Git aliases.
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gg="git gui"
alias gl="git lg"
alias gm="git merge"
alias gp="git pull"
alias gr="git rebase"
alias gs="git status"
alias gt="git tag"

# Root aliases.
if [ "$(id --user)" = 0 ]
then
	alias rm="rm --interactive"
	alias cp="cp --interactive"
	alias mv="mv --interactive"
fi

# Helper to add a path in the PATH.
function addtopath() {
	[ -d "${1}" ] && [[ "${PATH}" != *"${1}"* ]] && PATH="${1}:${PATH}"
}

#
# Miscellaneous.
#

# Check the window size after each command.
shopt -s checkwinsize

# Enable programmable completion features.
[ -f /etc/bash_completion ] && ! shopt -oq posix && source /etc/bash_completion

# Add user's private bin to PATH.
addtopath "${HOME}/.local/bin"

# Allow other private configuration.
[ -f "${HOME}/.bash_priv" ] && source "${HOME}/.bash_priv"
