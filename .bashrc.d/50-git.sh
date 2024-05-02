# Git aliases.
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gd="git diff"
alias gl="git lg"
alias gs="git status"

if [ -x /usr/lib/git-core/git-gui ]; then
	alias gg="git gui"
fi

if has gitk; then
	alias gk="gitk"
fi

# Enable completion for git aliases.
if sourceme /usr/share/bash-completion/completions/git; then
	__git_complete g git
	__git_complete ga git_add
	__git_complete gb git_branch
	__git_complete gc git_checkout
	__git_complete gd git_diff
	__git_complete gl git_log
	__git_complete gs git_status

	if has gitk; then
		__git_complete gk gitk
	fi
fi
