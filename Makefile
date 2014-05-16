#
# This is the main file of the one time setup system
#

# Do not print "Entering directory ...";
MAKEFLAGS += --no-print-directory

# Import configuration
-include .config

# Support the V= option in command line
ifeq ("$(origin V)", "command line")
VERBOSITY	:= $(V)
else
VERBOSITY	:= 0
endif

# Define the verbosity level
ifeq ($(VERBOSITY), 2)
QUIET		:=
PRINT0		:= @printf "  %-7.7s %s\n"
PRINT1		:= @printf "  %-7.7s %s\n"
else ifeq ($(VERBOSITY), 1)
QUIET		:= @
PRINT0		:= @printf "  %-7.7s %s\n"
PRINT1		:= @printf "  %-7.7s %s\n"
else
QUIET		:= @
PRINT0		:= @true
PRINT1		:= @printf "  %-7.7s %s\n"
endif

# Support the F= option in command line
ifeq ("$(origin F)", "command line")
FORCE		:= $(F)
endif

# Check Linux Standard Base
ifneq ($(FORCE), 1)
LSB_DISTRIB	:= $(shell lsb_release -i | sed -n 's/^[^\t]*\t\(.*\)$$/\L\1/p')
LSB_RELEASE	:= $(shell lsb_release -r | sed -n 's/^[^\t]*\t\(.*\)$$/\1/p')

# Supported distributions:
# - ubuntu 14.04

ifeq ($(LSB_DISTRIB)_$(LSB_RELEASE), ubuntu_14.04)
else
$(error This distribution is not supported. Use 'make F=1' to override.)
endif
endif

# Define global variables
USER_NAME	?= John Doe
USER_EMAIL	?= jdoe@example.com
MACHINE_TYPE	?= server
MACHINE_ACCESS	?= user
CONFIG_THEME	?= none

# Define global commands
ifeq ($(MACHINE_ACCESS), admin)
SUDO		:= sudo
endif

CP		:= cp -b
MKDIR		:= mkdir -p
MV		:= mv -b
RM		:= rm -f
SED		:= sed -i

S_CP		:= $(SUDO) cp -b
S_MKDIR		:= $(SUDO) mkdir -p
S_MV		:= $(SUDO) mv -b
S_RM		:= $(SUDO) rm -f
S_SED		:= $(SUDO) sed -i

ifeq ($(VERBOSITY), 2)
WGET		:= wget --debug --output-document
else
WGET		:= wget --quiet --output-document
endif

# That's our default target when none is given on the command line
PHONY := all
all:

# Define the help target
PHONY += help
help:
	@echo  '		-= One Time Setup =-'
	@echo
	@echo  'Configuration file:'
	@echo  ' The one time setup read the .config file at startup. You can'
	@echo  ' easily create a .config file by copying the defconfig file.'
	@echo
	@echo  'Configuration option:'
	@echo  ' USER_NAME		: Your name'
	@echo  ' USER_EMAIL		: Your email'
	@echo  ' MACHINE_TYPE		: Your machine type:'
	@echo  '			   * desktop'
	@echo  '			   * server (default)'
	@echo  ' MACHINE_ACCESS		: Your access type on the machine'
	@echo  '			   * admin'
	@echo  '			   * user (default)'
	@echo  ' CONFIG_THEME		: The theme used for your terminals, IDE...'
	@echo  '			   * none (default)'
	@echo  '			   * solarized-dark'
	@echo  '			   * solarized-light'
	@find . -name help.mk -exec make -f {} help \;
	@echo
	@echo  'Command line options:'
	@echo  '  make V=0-2 [targets] 0 => quiet setup (default)'
	@echo  '                       1 => verbose setup'
	@echo  '                       2 => ultra verbose setup'
	@echo  '  make F=0-1 [targets] 0 => lsb check enable (default)'
	@echo  '                       1 => lsb check disable'

# Add module mk files in this order:
# 1 - distrib_release.mk
# 2 - distrib.mk
# 3 - default.mk
define findmk
$(shell test -r $(1)/$(LSB_DISTRIB)_$(LSB_RELEASE).mk && \
	echo $(1)/$(LSB_DISTRIB)_$(LSB_RELEASE).mk || \
	{ test -r $(1)/$(LSB_DISTRIB).mk && echo $(1)/$(LSB_DISTRIB).mk || \
	{ test -r $(1)/default.mk && echo $(1)/default.mk; }; } )
endef

$(foreach mod,$(shell find . -type d),\
	$(eval mk=$(call findmk,$(mod)))$(if $(mk),$(eval include $(mk))))

# Declare the contents of the .PHONY variable as phony.
.PHONY: $(PHONY)
