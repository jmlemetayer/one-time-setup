#
# Devtools setup rules
#

# Add devtools into the target list
PHONY += devtools

ifdef CONFIG_DEVTOOLS
all: devtools
endif

# Define the devtools target
devtools: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install build-essential autoconf automake \
		libtool libncurses5-dev valgrind gdb pkg-config
endif
ifeq ($(MACHINE_TYPE), desktop)
	$(PRINT0) MKDIR "$(HOME)/development"
	$(QUIET) $(MKDIR) $(HOME)/development
endif
