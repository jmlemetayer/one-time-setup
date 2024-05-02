# ~/.bash_logout: executed by bash(1) when login shell exits.

# If exiting the last bash instance. Read bash(1) for more info.
if [ "${SHLVL}" = 1 ]; then
	# Clear console to increase privacy.
	[ -x "$(which clear_console)" ] && clear_console --quiet
fi
