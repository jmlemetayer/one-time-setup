#
# Shell setup rules
#

ifdef CONFIG_SHELL

# Add shell into the target list
PHONY += shell
all: shell

# Define the shell target
shell:
	$(PRINT1) CONFIG "$@"
	$(PRINT0) COPY "$(HOME)/.profile"
	$(QUIET) $(CP) shell/profile $(HOME)/.profile
	$(PRINT0) COPY "$(HOME)/.shrc"
	$(QUIET) $(CP) shell/shrc $(HOME)/.shrc
	$(PRINT0) COPY "$(HOME)/.sh_aliases"
	$(QUIET) $(CP) shell/sh_aliases $(HOME)/.sh_aliases
endif
