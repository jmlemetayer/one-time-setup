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
ifeq ($(MACHINE_RIGHTS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install bash bash-completion
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) COPY "$(HOME)/.bashrc"
	$(QUIET) $(CP) bash/bashrc $(HOME)/.bashrc
	$(PRINT0) COPY "$(HOME)/.bash_aliases"
	$(QUIET) $(CP) bash/bash_aliases $(HOME)/.bash_aliases
ifeq ($(CONFIG_THEME), solarized)
	$(PRINT0) WGET "$(HOME)/.dircolors"
	$(QUIET) $(WGET) $(HOME)/.dircolors $(BASH_SOLARIZED)
else
	$(PRINT0) RM "$(HOME)/.dircolors"
	$(QUIET) $(RM) -r $(HOME)/.dircolors
endif
