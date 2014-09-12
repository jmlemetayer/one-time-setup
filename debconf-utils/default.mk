#
# Debconf-utils setup rules
#

# Define the debconf-utils target
PHONY += debconf-utils
debconf-utils:
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(QUIET) $(S_PACKAGE) install debconf-utils
	$(PRINT1) CONFIG "$@"
	$(QUIET) cat debconf-utils/debconf-utils.debconf | $(SUDO) debconf-set-selections
endif
