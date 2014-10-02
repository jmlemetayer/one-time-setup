#
# Chromium setup rules
#

# Add chromium into the target list
PHONY += chromium

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_CHROMIUM
all: chromium
endif
endif

# Define the chromium target
chromium: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install chromium-browser
ifeq ($(VERBOSITY), 2)
	$(QUIET) $(S_PACKAGE) install pepperflashplugin-nonfree
else
	$(QUIET) $(S_PACKAGE) install pepperflashplugin-nonfree 2>/dev/null
endif
	$(QUIET) $(SUDO) update-pepperflashplugin-nonfree --install
endif
	$(PRINT1) CONFIG "$@"
	$(QUIET) xdg-settings set default-web-browser chromium-browser.desktop
