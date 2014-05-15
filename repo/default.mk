#
# Repo setup rules
#

# Repo url on google storage
REPO_URL=http://commondatastorage.googleapis.com/git-repo-downloads/repo

# Add repo into the target list
PHONY += repo

ifdef CONFIG_REPO
all: repo
endif

# Shell dependencies if not admin
ifeq ($(MACHINE_RIGHTS), user)
repo: shell
endif

# Define the repo target
repo: git
	$(PRINT1) INSTALL "$@"
ifeq ($(MACHINE_RIGHTS), admin)
	$(PRINT0) WGET "$@"
	$(QUIET) $(SUDO) $(WGET) /usr/bin/repo $(REPO_URL)
	$(PRINT0) CHMOD "$@"
	$(QUIET) $(SUDO) chmod 755 /usr/bin/repo
else
	$(PRINT0) WGET "$@"
	$(QUIET) $(WGET) $(HOME)/.bin/repo $(REPO_URL)
	$(PRINT0) CHMOD "$@"
	$(QUIET) chmod 755 $(HOME)/.bin/repo
endif
