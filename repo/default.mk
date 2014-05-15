#
# Repo setup rules
#

# Repo url on google storage
REPO_URL=http://commondatastorage.googleapis.com/git-repo-downloads/repo

# Repo completion script
REPO_COMPLETION=https://raw.githubusercontent.com/aartamonau/repo.bash_completion/master/repo.bash_completion

# Add repo into the target list
PHONY += repo

ifdef CONFIG_REPO
all: repo
endif

# Dependencies
ifeq ($(MACHINE_RIGHTS), admin)
repo: bash
else
repo: shell
endif

# Define the repo target
repo: git
	$(PRINT1) INSTALL "$@"
ifeq ($(MACHINE_RIGHTS), admin)
	$(PRINT0) WGET "repo"
	$(QUIET) $(SUDO) $(WGET) /usr/bin/repo $(REPO_URL)
	$(PRINT0) CHMOD "repo"
	$(QUIET) $(SUDO) chmod 755 /usr/bin/repo
	$(PRINT0) WGET "repo.bash_completion"
	$(QUIET) $(SUDO) $(WGET) /etc/bash_completion.d/repo $(REPO_COMPLETION)
else
	$(PRINT0) WGET "$@"
	$(QUIET) $(WGET) $(HOME)/.bin/repo $(REPO_URL)
	$(PRINT0) CHMOD "$@"
	$(QUIET) chmod 755 $(HOME)/.bin/repo
endif
