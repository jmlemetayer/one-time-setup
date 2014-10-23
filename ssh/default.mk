#
# Ssh setup rules
#

# Add ssh into the target list
PHONY += ssh

ifdef CONFIG_SSH
all: ssh
endif

# Define the ssh target
ssh:
	$(PRINT1) CONFIG "$@"
ifeq ($(MACHINE_TYPE), server)
ifeq ($(VERBOSITY), 2)
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -t rsa -N "" -f $(HOME)/.ssh/id_rsa; fi
else
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -q -t rsa -N "" -f $(HOME)/.ssh/id_rsa; fi
endif
else
ifeq ($(VERBOSITY), 2)
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -t rsa -N "" -f $(HOME)/.ssh/id_rsa; \
		eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_rsa; fi
else
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -q -t rsa -N "" -f $(HOME)/.ssh/id_rsa; \
		eval "$(ssh-agent -s)" >/dev/null; \
		ssh-add ~/.ssh/id_rsa 2>/dev/null; fi
endif
endif
