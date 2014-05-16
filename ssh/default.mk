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
ifeq ($(VERBOSITY), 2)
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -t rsa -N "" -f $(HOME)/.ssh/id_rsa; fi
else
	$(QUIET) if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		ssh-keygen -q -t rsa -N "" -f $(HOME)/.ssh/id_rsa; fi
endif
