# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set color
[ -x /usr/bin/tput ] && tput setaf 1 >/dev/null && COLOR_PROMPT=yes
# We have color support; assume it's compliant with Ecma-48
# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# a case would tend to support setf rather than setaf.)
[[ ${TERM} = rxvt* || ${TERM} = xterm* ]] && XTERM=yes

[ -n "${XTERM}" ] && COLOR1='01;38;5;106' || COLOR1='01;32'
[ -n "${XTERM}" ] && COLOR2='01;38;5;33' || COLOR2='01;34'

if [ -n "${COLOR_PROMPT}" ]
then
	PS1="\[\033[${COLOR1}m\]\u@\h\[\033[0m\]:\[\033[${COLOR2}m\]\w\[\033[0m\]\$ "
else
	PS1='\u@\h:\w\$ '
fi

unset COLOR1
unset COLOR2

# Enable color support for the basic commands
if [ -x /usr/bin/dircolors ]
then
	if [ -r ${HOME}/.dircolors -a -n "${XTERM}" ]
	then
		eval "$(dircolors -b ${HOME}/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi

	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

unset XTERM
unset COLOR_PROMPT

# Add to path function
function addtopath()
{
	[ -d "$1" ] && [[ "$PATH" != *"$1"* ]] && export PATH="$1:$PATH"
}

# Add user's private bin to path
addtopath "${HOME}/.local/bin"

# Basic alias definitions
[ -f ~/.sh_aliases ] && . ~/.sh_aliases

# Alias definitions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Private configuration
[ -f ~/.bash_priv ] && . ~/.bash_priv

# Enable programmable completion features
[ -f /etc/bash_completion ] && ! shopt -oq posix && . /etc/bash_completion
