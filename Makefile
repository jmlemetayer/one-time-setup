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
LSB_DISTRIB	:= $(shell lsb_release -s -i | sed -n 's/^\(.*\)$$/\L\1/p')
LSB_RELEASE	:= $(shell lsb_release -s -r | sed -n 's/^\(.*\)$$/\L\1/p')
LSB_DESCRIPTION	:= $(LSB_DISTRIB)_$(LSB_RELEASE)

ifneq ($(FORCE), 1)
# Supported distributions:
LSB_SUPPORTED := ubuntu_14.04

ifneq ($(LSB_DESCRIPTION), $(filter $(LSB_SUPPORTED), $(LSB_DESCRIPTION)))
$(error This distribution is not supported yet. Use 'make F=1' to override.)
endif
endif

# Display the distribution debug trace
ifeq ($(VERBOSITY), 2)
$(info Installing on $(shell lsb_release -s -d) as $(LSB_DESCRIPTION))
endif

# Define global variables
USER_NAME	?= John Doe
USER_EMAIL	?= jdoe@example.com
MACHINE_TYPE	?= server
MACHINE_ACCESS	?= user
CONFIG_THEME	?= none

# Check global variables
MACHINE_TYPES	:= desktop
MACHINE_TYPES	+= server

ifneq ($(MACHINE_TYPE), $(filter $(MACHINE_TYPE), $(MACHINE_TYPES)))
$(error Unknown MACHINE_TYPE: $(MACHINE_TYPE))
endif

MACHINE_ACCESSS	:= admin
MACHINE_ACCESSS	+= user

ifneq ($(MACHINE_ACCESS), $(filter $(MACHINE_ACCESS), $(MACHINE_ACCESSS)))
$(error Unknown MACHINE_ACCESS: $(MACHINE_ACCESS))
endif

CONFIG_THEMES	:= none
CONFIG_THEMES	+= solarized-dark
CONFIG_THEMES	+= solarized-light

ifneq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), $(CONFIG_THEMES)))
$(error Unknown CONFIG_THEME: $(CONFIG_THEME))
endif

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

# List modules
define listmod
$(shell find . -maxdepth 1 -type d | sort)
endef

# Print a parameter
# 1 - Parameter name
# 2 - Parameter type
# 3 - Parameter description
define param_print
$(if $(filter-out a,$(strip $(2)))
	,$(shell echo printf \' %-22.22s \(%s\) : %s\\n\' \'$(strip $(1))\' \'$(strip $(2))\' \'$(strip $(3))\' \;)
	,$(shell echo printf \' %-27.27s: %s\\n\' \'$(strip $(1))\' \'$(strip $(3))\' \;))
endef

# Print a bool parameter
# 1 - Parameter line
define param_bool
$(call param_print,$(shell echo $(1) | awk -F: '{print $$1}')\
	,$(shell echo $(1) | awk -F: '{print $$2}' | head -c1)
	,$(shell echo $(1) | awk -F: '{gsub("#", " ", $$4); print $$4}'))
endef

# Print a string parameter
# 1 - Parameter line
define param_string
$(call param_print,$(shell echo $(1) | awk -F: '{print $$1}')\
	,$(shell echo $(1) | awk -F: '{print $$2}' | head -c1)
	,$(shell echo $(1) | awk -F: '{gsub("#", " ", $$5); print $$5}'))
endef

# Print a list value
# 1 - List value
define value_print
$(shell echo printf \'\\t\\t\\t\\t\* %s\\n\' \'$(1)\' \;)
endef

# Print a list parameter
# 1 - Parameter line
define param_list
$(call param_print,$(shell echo $(1) | awk -F: '{print $$1}')\
	,$(shell echo $(1) | awk -F: '{print $$2}' | head -c1)
	,$(shell echo $(1) | awk -F: '{gsub("#", " ", $$6); print $$6}'))
$(foreach val,$(shell echo $(line) | \
	awk -F: '{gsub(/,/," ",$$5);print $$5}')\
	,$(call value_print,$(val)))
endef

# Parse a parameter file
# 1 - Parameter file
define param_parse
$(foreach line,$(shell cat $(1) | sed 's/ /#/g'),\
	$(if $(shell echo $(line) | grep ':bool:'),\
	$(call param_bool,$(line)),\
	$(if $(shell echo $(line) | grep ':string:'),\
	$(call param_string,$(line)),\
	$(if $(shell echo $(line) | grep ':list:'),\
	$(call param_list,$(line))))))
endef

# Define the help target
PHONY += help
help:
	@echo  '		-= One Time Setup =-'
	@echo
	@echo  'Configuration file:'
	@echo  ' The one time setup read the .config file at startup. You can'
	@echo  ' easily create a .config file by copying the defconfig file.'
	@echo
	@echo  'Configuration parameters:'
	@echo  ' Here is the list of all the parameters available. Note that (d) means'
	@echo  ' that it is a desktop only parameter and (s) a server only parameter.'
	@echo
	@$(foreach mod,$(call listmod),\
		$(if $(shell [ -r $(mod)/parameters ] && echo y),\
		$(call param_parse,$(mod)/parameters)))
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

$(foreach mod,$(call listmod),\
	$(eval mk=$(call findmk,$(mod)))$(if $(mk),$(eval include $(mk))))

# Declare the contents of the .PHONY variable as phony.
.PHONY: $(PHONY)
