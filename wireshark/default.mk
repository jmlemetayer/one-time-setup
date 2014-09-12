#
# Wireshark setup rules
#

# Add wireshark into the target list
PHONY += wireshark

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_WIRESHARK
all: wireshark
endif
endif

# Define the wireshark target
wireshark: package-update debconf-utils
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) cat wireshark/wireshark.debconf | $(SUDO) debconf-set-selections
	$(QUIET) $(S_PACKAGE) install wireshark-common wireshark
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) MKDIR $(HOME)/.wireshark
	$(QUIET) $(MKDIR) $(HOME)/.wireshark
	$(PRINT0) CP preferences
	$(QUIET) $(CP) wireshark/preferences $(HOME)/.wireshark
	$(PRINT0) CP colorfilters
	$(QUIET) $(CP) wireshark/colorfilters $(HOME)/.wireshark
ifeq ($(MACHINE_ACCESS), admin)
ifneq ($(shell id -u), 0)
	$(PRINT0) USERMOD wireshark
	$(QUIET) $(SUDO) usermod -a -G wireshark $(shell id -un)
endif
endif
