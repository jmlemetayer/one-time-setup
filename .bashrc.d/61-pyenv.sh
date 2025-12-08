export PYENV_ROOT="${HOME}/.pyenv"

addtopath "${PYENV_ROOT}/bin"

eval "$(pyenv init - bash)"
