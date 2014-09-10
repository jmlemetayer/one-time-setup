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
wireshark: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install wireshark
endif
	$(PRINT1) CONFIG "$@"
ifneq ($(shell id -u), 0)
	$(PRINT0) USERMOD wireshark
	$(QUIET) $(SUDO) usermod -a -G wireshark $(shell id -un)
endif
