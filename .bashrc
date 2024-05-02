# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything.
if [[ "${-}" != *i* ]]; then
	return
fi

# Include bashrc part files.
if [ -d "${HOME}"/.bashrc.d ]; then
	for BASHRC_FILE in "${HOME}"/.bashrc.d/*.sh; do
		if [ -r "${BASHRC_FILE}" ]; then
			. "${BASHRC_FILE}"
		fi
	done
	unset BASHRC_FILE
fi
