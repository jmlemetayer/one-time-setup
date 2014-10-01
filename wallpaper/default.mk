#
# Wallpaper setup rules
#

# Wallpaper urls
WALLPAPER_HEAD := http://www.tux-planet.fr/public/images/wallpapers/linux/ubuntu/
WALLPAPER_TAIL := -by-mikebeecham-1920x1080.png
WALLPAPER_URL := $(WALLPAPER_HEAD)$(CONFIG_WALLPAPER)$(WALLPAPER_TAIL)

# Wallpaper dconf path
WALLPAPER_PATH := /org/gnome/desktop/background/

# The wallpaper list
CONFIG_WALLPAPERS := radiance-purple
CONFIG_WALLPAPERS += simple-ubuntu-brown
CONFIG_WALLPAPERS += ubuntu-brown-bubbles
CONFIG_WALLPAPERS += ubuntu-brown
CONFIG_WALLPAPERS += ubuntu-fizz

# Add wallpaper into the target list
PHONY += wallpaper

ifeq ($(MACHINE_TYPE), desktop)
ifneq ($(CONFIG_WALLPAPER),)
ifneq ($(CONFIG_WALLPAPER), $(filter $(CONFIG_WALLPAPER), $(CONFIG_WALLPAPERS)))
$(error Unknown CONFIG_WALLPAPER: $(CONFIG_WALLPAPER))
else
all: wallpaper
endif
endif
endif

# Define the wallpaper target
wallpaper:
	$(PRINT1) INSTALL "$@"
	$(PRINT0) WGET "$(HOME)/.wallpaper"
	$(QUIET) $(WGET) $(HOME)/.wallpaper $(WALLPAPER_URL)
	$(PRINT1) CONFIG "$@"
	$(QUIET) dconf reset -f $(WALLPAPER_PATH)
	$(QUIET) dconf write $(WALLPAPER_PATH)picture-uri \
		"'file://$(HOME)/.wallpaper'"
