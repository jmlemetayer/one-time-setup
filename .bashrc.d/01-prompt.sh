# Customize the bash(1) prompt. Read the bash(1) PROMPTING paragraph for more
# info about the PS1 formatting. Check this URL for more info about ANSI escape
# codes: https://en.wikipedia.org/wiki/ANSI_escape_code
if [ "$(id --user)" = 0 ]; then
	PS1='\[\033[31m\]\u@\H\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ '
else
	PS1='\[\033[32m\]\u@\H\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ '
fi
