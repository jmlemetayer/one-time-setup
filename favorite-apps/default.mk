#
# Favorite apps setup rules
#

# The favorite apps varaibles
FA_PATH := /org/gnome/shell/favorite-apps

ifdef CONFIG_CHROMIUM
FA_APPS := 'chromium-browser.desktop',
else
FA_APPS := 'firefox.desktop',
endif

ifdef CONFIG_GNOME_TERMINAL
FA_APPS += 'gnome-terminal.desktop',
endif

ifdef CONFIG_DEVTOOLS
FA_APPS += 'glogg.desktop',
endif

FA_APPS += 'nautilus.desktop'

# Add favorite apps into the target list
PHONY += favorite-apps

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_FAVORITE_APPS
all: favorite-apps
endif
ifdef CONFIG_CHROMIUM
favorite-apps: chromium
endif
ifdef CONFIG_GNOME_TERMINAL
favorite-apps: gnome-terminal
endif
ifdef CONFIG_DEVTOOLS
favorite-apps: devtools
endif
endif

# Define the favorite apps target
favorite-apps:
	$(PRINT1) CONFIG "$@"
	$(QUIET) dconf write $(FA_PATH) "[$(FA_APPS)]"
