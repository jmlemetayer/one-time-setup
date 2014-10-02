#
# Gravatar setup rules
#

# The gravatar url
GRAVATAR_EMAIL := $(shell echo $(strip $(USER_EMAIL)) | tr A-Z a-z)
GRAVATAR_HASH := $(firstword $(shell echo -n $(GRAVATAR_EMAIL) | md5sum))
GRAVATAR_URL := http://www.gravatar.com/avatar/$(GRAVATAR_HASH)?size=96

# Add gravatar into the target list
PHONY += gravatar

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_GRAVATAR
ifeq ($(USER_EMAIL),)
$(error USER_EMAIL is empty can not configure gravatar)
endif
all: gravatar
endif
endif

# Define the gravatar target
gravatar:
	$(PRINT1) CONFIG "$@"
	$(PRINT0) WGET "/tmp/gravatar"
	$(QUIET) $(WGET) /tmp/gravatar $(GRAVATAR_URL)
	$(PRINT0) DBUS "SetIconFile"
	$(QUIET) dbus-send --system --print-reply=literal \
		--dest=org.freedesktop.Accounts \
		/org/freedesktop/Accounts/User$(shell id -u) \
		org.freedesktop.Accounts.User.SetIconFile \
		string:"/tmp/gravatar"
	$(PRINT0) RM "/tmp/gravatar"
	$(QUIET) $(RM) "/tmp/gravatar"
