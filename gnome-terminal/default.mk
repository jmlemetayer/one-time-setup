#
# Gnome-terminal setup rules
#

# Gnome terminal gconf path
GT_PATH := /apps/gnome-terminal
GT_PROFILE := $(GT_PATH)/profiles/User
GT_GLOBAL := $(GT_PATH)/global

# The gnome terminal solarized palette url
GT_SOLARIZED := https://github.com/sigurdga/solarized/raw/master/gnome-terminal-colors-solarized/colors/palette

# Gnome terminal profile list
ifeq ($(MACHINE_TYPE), desktop)
GT_LIST := $(shell gconftool-2 --get $(GT_GLOBAL)/profile_list)
GT_LIST := $(shell echo $(GT_LIST) | sed -e 's/\[//g' -e 's/\]//g')
endif

# Add gnome-terminal into the target list
PHONY += gnome-terminal

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_GNOME_TERMINAL
ifeq ($(USER_NAME),)
$(error USER_NAME is empty can not configure gnome-terminal)
endif
all: gnome-terminal
endif
endif

# Define the gnome-terminal target
gnome-terminal: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install gnome-terminal
endif
	$(PRINT1) CONFIG "$@"
	$(QUIET) gconftool-2 --recursive-unset $(GT_PROFILE)
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/alternate_screen_scroll \
		--type bool true
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/default_show_menubar \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/scrollback_lines \
		--type int 1024
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/scrollbar_position \
		--type string hidden
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/silent_bell \
		--type bool true
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/use_theme_colors \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/visible_name \
		--type string '$(USER_NAME)'
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/bold_color_same_as_fg \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/palette \
		--type string '$(shell $(WGET) - $(GT_SOLARIZED))'
ifeq ($(CONFIG_THEME), solarized-dark)
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/background_color \
		--type string '#00002B2B3636'
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/bold_color \
		--type string '#9393a1a1a1a1'
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/foreground_color \
		--type string '#838394949696'
else
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/background_color \
		--type string '#fdfdf6f6e3e3'
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/bold_color \
		--type string '#58586e6e7575'
	$(QUIET) gconftool-2 --set $(GT_PROFILE)/foreground_color \
		--type string '#65657b7b8383'
endif
else
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/background_color
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/bold_color
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/bold_color_same_as_fg
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/foreground_color
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/palette
	$(QUIET) gconftool-2 --unset $(GT_PROFILE)/use_theme_colors
endif
	$(QUIET) if [ $(shell echo $(GT_LIST) | grep -c User) = 0 ]; then \
		gconftool-2 --set $(GT_GLOBAL)/profile_list \
		--type list --list-type string '[$(GT_LIST),User]'; fi
	$(QUIET) gconftool-2 --set $(GT_GLOBAL)/default_profile \
		--type string User
