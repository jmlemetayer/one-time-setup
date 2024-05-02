# Basic aliases.
alias ll="ls --format=long"
alias la="ll --almost-all"
alias mkdir="mkdir --parents"

# Misunderstood aliases.
alias cd..="cd .."
alias l="ll"
alias mroe="more"
alias pdw="pwd"

# Root aliases.
if [ "$(id --user)" = 0 ]; then
	alias rm="rm --interactive"
	alias cp="cp --interactive"
	alias mv="mv --interactive"
fi
