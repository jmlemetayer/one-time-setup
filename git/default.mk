#
# Git setup rules
#

# Add git into the target list
PHONY += git

ifdef CONFIG_GIT

ifeq ($(USER_NAME),)
$(error USER_NAME is empty can not configure git)
endif

ifeq ($(USER_EMAIL),)
$(error USER_EMAIL is empty can not configure git)
endif

all: git
endif

# Define the git target
git: package-update
ifeq ($(MACHINE_RIGHTS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
ifeq ($(MACHINE_TYPE), server)
	$(QUIET) $(S_PACKAGE) install git
else
	$(QUIET) $(S_PACKAGE) install git gitk git-gui
endif
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) CREATE "$(HOME)/.gitconfig"
	$(QUIET) git config --global user.name "$(USER_NAME)"
	$(QUIET) git config --global user.email "$(USER_EMAIL)"
	$(QUIET) git config --global color.ui true
