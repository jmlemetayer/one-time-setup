# Get configuration
ifneq ($(shell ls .config), .config)
 $(error You have to create a '.config' file. \
	 You can run: 'cp defconfig .config')
endif

include .config

ifndef USER_NAME
 USER_NAME	:= "John Doe"
 $(warning Setting default value for USER_NAME)
endif

ifndef USER_EMAIL
 USER_EMAIL	:= "johndoe@example.com"
 $(warning Setting default value for USER_EMAIL)
endif

ifndef MACHINE_TYPE
 MACHINE_TYPE	:= server
 $(warning Setting default value for MACHINE_TYPE)
endif

# Check Linux Standard Base
ifndef FORCE
 LSB_NAME	:= $(shell lsb_release -i | \
	 sed -n 's/^[^:]*:\t\(.*\)$$/\1/p')
 LSB_VERSION := $(shell lsb_release -r | \
	 sed -n 's/^[^:]*:\t\([0-9]*\).*$$/\1/p')

 ifeq ($(LSB_NAME), Debian)
  ifneq ($(shell expr $(LSB_VERSION) \>= 7), 1)
   $(error Working only on Debian 7 or newer)
  endif
 else ifeq ($(LSB_NAME), Ubuntu)
  ifneq ($(shell expr $(LSB_VERSION) \>= 12), 1)
   $(error Working only on Ubuntu 12.04 or newer)
  endif
 else
  $(error This distribution is not supported. \
	  Use 'make FORCE=y' to override.)
 endif
endif

# Set functions
ifndef DEBUG
 QUIET		:= @
else
 QUIET		:=
endif

PRINT		:= @printf
INFO		:= $(PRINT)	"\t\033[1m%s\033[0m\n"
SUCCESS		:= $(PRINT)	"\t\033[1;32m%s\033[0m\n"

SUDO		:= $(QUIET)	sudo
CP_B		:= $(QUIET)	cp -b
S_CP_B		:= $(SUDO)	cp -b
MKDIR_P		:= $(QUIET)	mkdir -p
S_MKDIR_P	:= $(SUDO)	mkdir -p
MV_B		:= $(QUIET)	mv -b
S_MV_B		:= $(SUDO)	mv -b
SED_I		:= $(QUIET)	sed -i
S_SED_I		:= $(SUDO)	sed -i

ifndef DEBUG
 S_APT_GET	:= $(SUDO)	apt-get -qq
else
 S_APT_GET	:= $(SUDO)	apt-get -y
endif

# Set targets
ifdef CONFIG_PROFILE
 TARGETS	+= profile
endif

ifdef CONFIG_BASH
 TARGETS	+= bash
endif

ifdef CONFIG_VIM
 TARGETS	+= vim
endif

ifdef CONFIG_GIT
 TARGETS	+= git
endif

ifdef CONFIG_TOOLS
 TARGETS	+= tools
endif

ifdef CONFIG_DEVTOOLS
 TARGETS	+= devtools
endif

ifeq ($(MACHINE_TYPE), desktop)
 ifdef CONFIG_USER_DIRS
  TARGETS	+= user-dirs
 endif

 ifdef CONFIG_GNOME_TERMINAL
  TARGETS	+= gnome-terminal
 endif

 ifdef CONFIG_WALLPAPER
  TARGETS	+= wallpaper
 endif
endif

all: $(TARGETS)

# Basic rules
.PHONY: sudo
sudo:
	$(SUDO) true

.PHONY: update
update: sudo
	$(INFO) "Updating packages"
	$(S_APT_GET) update
	$(SUCCESS) "All packages are updated"

# Application rules
.PHONY: profile
profile:
	$(INFO) "Configuring $@"
	$(MKDIR_P) $(HOME)/.bin
	$(CP_B) profile/profile $(HOME)/.profile
	$(SUCCESS) "$@ is configured"

.PHONY: bash
bash: profile tools
	$(INFO) "Configuring $@"
	$(CP_B) bash/bashrc $(HOME)/.bashrc
	$(CP_B) bash/bash_aliases $(HOME)/.bash_aliases
ifndef CONFIG_THEME_SOLARIZED
	$(SED_I) 's/COLOR1/01;32/' $(HOME)/.bashrc
	$(SED_I) 's/COLOR2/01;34/' $(HOME)/.bashrc
	$(QUIET) rm -f $(HOME)/.dircolors
else
	$(SED_I) 's/COLOR1/01;38;5;106/' $(HOME)/.bashrc
	$(SED_I) 's/COLOR2/01;38;5;33/' $(HOME)/.bashrc
	$(QUIET)curl --silent --show-error --output $(HOME)/.dircolors \
		https://raw.github.com/seebi/dircolors-solarized/master/dircolors.256dark
endif
	$(SUCCESS) "$@ is configured"

.PHONY: vim
vim: update tools
	$(INFO) "Installing $@"
	$(S_APT_GET) install vim vim-gnome
	$(INFO) "Configuring $@"
	$(MKDIR_P) $(HOME)/.vim/backup $(HOME)/.vim/tmp
	$(CP_B) vim/vimrc $(HOME)/.vimrc
ifndef CONFIG_THEME_SOLARIZED
	$(QUIET) rm -rf $(HOME)/.vim/colors
else
	$(MKDIR_P) $(HOME)/.vim/colors
	$(QUIET)curl --silent --show-error --output $(HOME)/.vim/colors/solarized.vim \
		https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) echo '" Solarized' >> $(HOME)/.vimrc
	$(QUIET) echo 'if $$TERM =~ "^xterm" || $$TERM =~ "^rxvt"' >> $(HOME)/.vimrc
	$(QUIET) echo '	syntax enable' >> $(HOME)/.vimrc
	$(QUIET) echo '	set background=dark' >> $(HOME)/.vimrc
	$(QUIET) echo '	let g:solarized_termtrans=1' >> $(HOME)/.vimrc
	$(QUIET) echo '	colorscheme solarized' >> $(HOME)/.vimrc
	$(QUIET) echo 'endif' >> $(HOME)/.vimrc
endif
	$(SUCCESS) "$@ is installed"

.PHONY: git
git: update
	$(INFO) "Installing $@"
	$(S_APT_GET) install git-core git-gui gitk
	$(INFO) "Configuring $@"
	$(QUIET) git config --global user.name $(USER_NAME)
	$(QUIET) git config --global user.email $(USER_EMAIL)
	$(QUIET) git config --global color.ui true
	$(SUCCESS) "$@ is installed"

.PHONY: tools
tools: update
	$(INFO) "Installing $@"
	$(S_APT_GET) install curl sqlite3 tree unzip
	$(SUCCESS) "$@ is installed"

.PHONY: devtools
devtools: update
	$(INFO) "Installing $@"
	$(S_APT_GET) install build-essential autoconf automake libtool valgrind
	$(INFO) "Configuring $@"
	$(MKDIR_P) $(HOME)/development
	$(SUCCESS) "$@ is installed"

ifeq ($(MACHINE_TYPE), desktop)
.PHONY: user-dirs
user-dirs:
	$(INFO) "Configuring $@"
ifneq ("$(shell xdg-user-dir DESKTOP)", "$(HOME)/.desktop")
	$(MV_B) "$(shell xdg-user-dir DESKTOP)" "$(HOME)/.desktop"
	$(QUIET) xdg-user-dirs-update --set DESKTOP "$(HOME)/.desktop"
endif
ifneq ("$(shell xdg-user-dir DOWNLOAD)", "$(HOME)/downloads")
	$(MV_B) "$(shell xdg-user-dir DOWNLOAD)" "$(HOME)/downloads"
	$(QUIET) xdg-user-dirs-update --set DOWNLOAD "$(HOME)/downloads"
endif
ifneq ("$(shell xdg-user-dir TEMPLATES)", "$(HOME)/.templates")
	$(MV_B) "$(shell xdg-user-dir TEMPLATES)" "$(HOME)/.templates"
	$(QUIET) xdg-user-dirs-update --set TEMPLATES "$(HOME)/.templates"
endif
ifneq ("$(shell xdg-user-dir PUBLICSHARE)", "$(HOME)/www")
	$(MV_B) "$(shell xdg-user-dir PUBLICSHARE)" "$(HOME)/www"
	$(QUIET) xdg-user-dirs-update --set PUBLICSHARE "$(HOME)/www"
endif
ifneq ("$(shell xdg-user-dir DOCUMENTS)", "$(HOME)/documents")
	$(MV_B) "$(shell xdg-user-dir DOCUMENTS)" "$(HOME)/documents"
	$(QUIET) xdg-user-dirs-update --set DOCUMENTS "$(HOME)/documents"
endif
ifneq ("$(shell xdg-user-dir VIDEOS)", "$(HOME)/videos")
	$(MV_B) "$(shell xdg-user-dir VIDEOS)" "$(HOME)/videos"
	$(QUIET) xdg-user-dirs-update --set VIDEOS "$(HOME)/videos"
endif
ifneq ("$(shell xdg-user-dir MUSIC)", "$(HOME)/music")
	$(MV_B) "$(shell xdg-user-dir MUSIC)" "$(HOME)/music"
	$(QUIET) xdg-user-dirs-update --set MUSIC "$(HOME)/music"
endif
ifneq ("$(shell xdg-user-dir PICTURES)", "$(HOME)/pictures")
	$(MV_B) "$(shell xdg-user-dir PICTURES)" "$(HOME)/pictures"
	$(QUIET) xdg-user-dirs-update --set PICTURES "$(HOME)/pictures"
endif
	$(SUCCESS) "$@ is configured"

GT_PATH		:= /apps/gnome-terminal
GT_PROFILES := $(shell gconftool-2 --get $(GT_PATH)/global/profile_list)
GT_PROFILES := $(shell echo $(GT_PROFILES) | sed -e 's/\[//g' -e 's/\]//g')
.PHONY: gnome-terminal
gnome-terminal: update
	$(INFO) "Installing $@"
	$(S_APT_GET) install gnome-terminal
	$(INFO) "Configuring $@"
	$(QUIET) gconftool-2 --recursive-unset $(GT_PATH)/profiles/User
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/visible_name \
		--type string $(USERNAME)
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/default_show_menubar \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/use_theme_colors \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/scrollbar_position \
		--type string hidden
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/scrollback_lines \
		--type int 1024
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/silent_bell \
		--type bool true
ifndef CONFIG_THEME_SOLARIZED
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/background_color \
		--type string '#300A24'
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/foreground_color \
		--type string '#FFFFFF'
else
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/background_color \
		--type string '#002B36'
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/foreground_color \
		--type string '#839496'
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/bold_color \
		--type string '#93A1A1'
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/bold_color_same_as_fg \
		--type bool false
	$(QUIET) gconftool-2 --set $(GT_PATH)/profiles/User/palette \
		--type string '#073642:#DC322F:#859900:#B58900:#268BD2:#D33682:#2AA198:#EEE8D5:#002B36:#CB4B16:#586E75:#657B83:#839496:#6C71C4:#93A1A1:#FDF6E3'
endif
ifeq ($(shell echo $(GT_PROFILES) | grep -c User), 0)
	$(QUIET) gconftool-2 --set $(GT_PATH)/global/profile_list \
		--type list --list-type string [$(GT_PROFILES),User]
endif
	$(QUIET) gconftool-2 --set $(GT_PATH)/global/default_profile \
		--type string User
	$(SUCCESS) "$@ is configured"

WP_SCHEMA	:= org.gnome.desktop.background
WP_PATH		:= /wallpaper/$(CONFIG_WALLPAPER).png
.PHONY: wallpaper
wallpaper:
	$(INFO) "Installing $@"
	$(CP_B) -r wallpaper/ "$(shell xdg-user-dir PICTURES)"
	$(INFO) "Configuring $@"
	$(QUIET) gsettings reset-recursively $(WP_SCHEMA)
	$(QUIET) test -f $(shell xdg-user-dir PICTURES)$(WP_PATH)
	$(QUIET) gsettings set $(WP_SCHEMA) picture-uri \
		"file://$(shell xdg-user-dir PICTURES)$(WP_PATH)"
	$(SUCCESS) "$@ is configured"
endif
