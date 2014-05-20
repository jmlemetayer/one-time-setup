#
# bash setup rules
#

# Bash dircolors for solarized
BASH_SOLARIZED=https://raw.github.com/seebi/dircolors-solarized/master/dircolors.256dark

# Add bash into the target list
PHONY += bash

ifdef CONFIG_BASH
all: bash
endif

# Define the bash target
bash: shell package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install bash bash-completion
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) GEN "$(HOME)/.bashrc"
	$(QUIET) $(CP) bash/bashrc.head $(HOME)/.bashrc
	$(QUIET) echo >> $(HOME)/.bashrc
ifeq ($(shell id -u), 0)
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(QUIET) cat bash/bashrc.root.solarized >> $(HOME)/.bashrc
else
	$(QUIET) cat bash/bashrc.root.none >> $(HOME)/.bashrc
endif
else
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(QUIET) cat bash/bashrc.user.solarized >> $(HOME)/.bashrc
else
	$(QUIET) cat bash/bashrc.user.none >> $(HOME)/.bashrc
endif
endif
	$(QUIET) echo >> $(HOME)/.bashrc
	$(QUIET) cat bash/bashrc.tail >> $(HOME)/.bashrc
	$(PRINT0) GEN "$(HOME)/.bash_aliases"
	$(QUIET) $(CP) bash/bash_aliases $(HOME)/.bash_aliases
	$(QUIET) echo >> $(HOME)/.bash_aliases
	$(QUIET) cat bash/bash_aliases.ubuntu >> $(HOME)/.bash_aliases
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(PRINT0) WGET "$(HOME)/.dircolors"
	$(QUIET) $(WGET) $(HOME)/.dircolors $(BASH_SOLARIZED)
else
	$(PRINT0) RM "$(HOME)/.dircolors"
	$(QUIET) $(RM) -r $(HOME)/.dircolors
endif
