# Verbosity
QUIET		:= @

# Functions
INFO		:= @printf "\t\033[1m%s\033[0m\n"
SUCCESS		:= @printf "\t\033[1;32m%s\033[0m\n"
SUDO		:= $(QUIET)sudo
S_APT_GET	:= $(SUDO) apt-get -y
CP_B		:= $(QUIET)cp -b
S_CP_B		:= $(SUDO) cp -b
MKDIR_P		:= $(QUIET)mkdir -p
S_MKDIR_P	:= $(SUDO) mkdir -p
MV_B		:= $(QUIET)mv -b
S_MV_B		:= $(SUDO) mv -b
SED_I		:= $(QUIET)sed -i
S_SED_I		:= $(SUDO) sed -i

# Check Linux Standard Base
LSB_NAME	:= $(shell lsb_release -i | sed -n 's/^[^:]*:\t\(.*\)$$/\1/p')
LSB_VERSION	:= $(shell lsb_release -r | sed -n 's/^[^:]*:\t\([^\.]*\)\.\(.*\)$$/\1\2/p')

ifneq ($(LSB_NAME), Ubuntu)
 $(error Working only on Ubuntu)
endif

ifneq ($(shell expr $(LSB_VERSION) \>= 1204), 1)
 $(error Working only on Ubuntu 12.04 or newer)
endif

# Include config
-include .config

ifneq ($(shell ls .config), .config)
 $(error You have to create a '.config' file. You can run: 'cp defconfig .config')
endif

# Check config
ifndef USERNAME
 USERNAME	:= "John Doe"
 $(warning Setting default value for USERNAME)
endif

ifndef USERMAIL
 USERMAIL	:= "johndoe@example.com"
 $(warning Setting default value for USERMAIL)
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

ifdef CONFIG_HAVE_GUI
 ifdef CONFIG_USER_DIRS
  TARGETS	+= user-dirs
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
bash: profile
	$(INFO) "Configuring $@"
	$(CP_B) bash/bashrc $(HOME)/.bashrc
	$(CP_B) bash/bash_aliases $(HOME)/.bash_aliases
	$(SUCCESS) "$@ is configured"

.PHONY: vim
vim: update
	$(INFO) "Installing $@"
	$(S_APT_GET) install vim
ifdef CONFIG_HAVE_GUI
	$(S_APT_GET) install vim-gnome
endif
	$(INFO) "Configuring $@"
	$(MKDIR_P) $(HOME)/.vim/backup
	$(MKDIR_P) $(HOME)/.vim/tmp
	$(CP_B) vim/vimrc $(HOME)/.vimrc
	$(SUCCESS) "$@ is installed"

ifdef CONFIG_HAVE_GUI
.PHONY: user-dirs
user-dirs:
	$(INFO) "Configuring $@"
ifneq ("$(shell xdg-user-dir DESKTOP)", "$(HOME)/.desktop")
	$(MV_B) "$(shell xdg-user-dir DESKTOP)" "$(HOME)/.desktop"
	$(QUIET)xdg-user-dirs-update --set DESKTOP "$(HOME)/.desktop"
endif
ifneq ("$(shell xdg-user-dir DOWNLOAD)", "$(HOME)/downloads")
	$(MV_B) "$(shell xdg-user-dir DOWNLOAD)" "$(HOME)/downloads"
	$(QUIET)xdg-user-dirs-update --set DOWNLOAD "$(HOME)/downloads"
endif
ifneq ("$(shell xdg-user-dir TEMPLATES)", "$(HOME)/.templates")
	$(MV_B) "$(shell xdg-user-dir TEMPLATES)" "$(HOME)/.templates"
	$(QUIET)xdg-user-dirs-update --set TEMPLATES "$(HOME)/.templates"
endif
ifneq ("$(shell xdg-user-dir PUBLICSHARE)", "$(HOME)/www")
	$(MV_B) "$(shell xdg-user-dir PUBLICSHARE)" "$(HOME)/www"
	$(QUIET)xdg-user-dirs-update --set PUBLICSHARE "$(HOME)/www"
endif
ifneq ("$(shell xdg-user-dir DOCUMENTS)", "$(HOME)/documents")
	$(MV_B) "$(shell xdg-user-dir DOCUMENTS)" "$(HOME)/documents"
	$(QUIET)xdg-user-dirs-update --set DOCUMENTS "$(HOME)/documents"
endif
ifneq ("$(shell xdg-user-dir VIDEOS)", "$(HOME)/videos")
	$(MV_B) "$(shell xdg-user-dir VIDEOS)" "$(HOME)/videos"
	$(QUIET)xdg-user-dirs-update --set VIDEOS "$(HOME)/videos"
endif
ifneq ("$(shell xdg-user-dir MUSIC)", "$(HOME)/music")
	$(MV_B) "$(shell xdg-user-dir MUSIC)" "$(HOME)/music"
	$(QUIET)xdg-user-dirs-update --set MUSIC "$(HOME)/music"
endif
ifneq ("$(shell xdg-user-dir PICTURES)", "$(HOME)/pictures")
	$(MV_B) "$(shell xdg-user-dir PICTURES)" "$(HOME)/pictures"
	$(QUIET)xdg-user-dirs-update --set PICTURES "$(HOME)/pictures"
endif
	$(SUCCESS) "$@ is configured"
endif
