#
# Define default package rules
#

# Define the package command
ifeq ($(VERBOSITY), 2)
 S_PACKAGE	:= $(SUDO) apt-get -y
else
 S_PACKAGE	:= $(SUDO) apt-get -qq
endif

# Define the package-update target
PHONY += package-update
package-update:
ifeq ($(MACHINE_RIGHTS), admin)
	$(PRINT0) UPDATE "packages"
	$(QUIET) $(S_PACKAGE) update
endif
