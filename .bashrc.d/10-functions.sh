# Helper to add a path in the PATH.
# 1: path to add
addtopath() {
	if [ -d "${1}" ]; then
		if [[ "${PATH}" != *"${1}"* ]]; then
			PATH="${1}:${PATH}"
		fi
	fi
}

# Helper to source a file only if it exists.
# 1: path to source
sourceme() {
	if [ -f "${1}" ]; then
		. "${1}"
	fi
}

# Helper to check if a command exists.
# 1: binary name
has() {
	which "${1}" >/dev/null
}

# Helper to filter some grep results
# 1: delimiter (default: ':')
# 2: field (default: 1)
filter() {
	cut -d "${1:-:}" -f "${2:-1}" | sort -u
}
