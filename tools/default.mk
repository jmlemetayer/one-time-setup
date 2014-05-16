#
# Tools setup rules
#

# Add tools into the target list
PHONY += tools

ifdef CONFIG_TOOLS
all: tools
endif

# Define the tools target
tools: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
	$(QUIET) $(S_PACKAGE) install curl sqlite3 tree unzip
endif
