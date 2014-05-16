#
# User directories setup rules
#

# Add user-dirs into the target list
PHONY += user-dirs

ifeq ($(MACHINE_TYPE), desktop)
ifdef CONFIG_USER_DIRS
all: user-dirs
endif
endif

# Define the ssh target
user-dirs:
	$(PRINT1) CONFIG "$@"
	$(PRINT0) UPDATE "$(HOME)/.desktop"
	$(QUIET) if [ "$$(xdg-user-dir DESKTOP)" != "$(HOME)/.desktop" ]; then \
		$(MV) "$$(xdg-user-dir DESKTOP)" "$(HOME)/.desktop"; \
		xdg-user-dirs-update --set DESKTOP "$(HOME)/.desktop"; fi
	$(PRINT0) UPDATE "$(HOME)/documents"
	$(QUIET) if [ "$$(xdg-user-dir DOCUMENTS)" != "$(HOME)/documents" ]; then \
		$(MV) "$$(xdg-user-dir DOCUMENTS)" "$(HOME)/documents"; \
		xdg-user-dirs-update --set DOCUMENTS "$(HOME)/documents"; fi
	$(PRINT0) UPDATE "$(HOME)/downloads"
	$(QUIET) if [ "$$(xdg-user-dir DOWNLOAD)" != "$(HOME)/downloads" ]; then \
		$(MV) "$$(xdg-user-dir DOWNLOAD)" "$(HOME)/downloads"; \
		xdg-user-dirs-update --set DOWNLOAD "$(HOME)/downloads"; fi
	$(PRINT0) UPDATE "$(HOME)/music"
	$(QUIET) if [ "$$(xdg-user-dir MUSIC)" != "$(HOME)/music" ]; then \
		$(MV) "$$(xdg-user-dir MUSIC)" "$(HOME)/music"; \
		xdg-user-dirs-update --set MUSIC "$(HOME)/music"; fi
	$(PRINT0) UPDATE "$(HOME)/pictures"
	$(QUIET) if [ "$$(xdg-user-dir PICTURES)" != "$(HOME)/pictures" ]; then \
		$(MV) "$$(xdg-user-dir PICTURES)" "$(HOME)/pictures"; \
		xdg-user-dirs-update --set PICTURES "$(HOME)/pictures"; fi
	$(PRINT0) UPDATE "$(HOME)/.templates"
	$(QUIET) if [ "$$(xdg-user-dir TEMPLATES)" != "$(HOME)/.templates" ]; then \
		$(MV) "$$(xdg-user-dir TEMPLATES)" "$(HOME)/.templates"; \
		xdg-user-dirs-update --set TEMPLATES "$(HOME)/.templates"; fi
	$(PRINT0) UPDATE "$(HOME)/videos"
	$(QUIET) if [ "$$(xdg-user-dir VIDEOS)" != "$(HOME)/videos" ]; then \
		$(MV) "$$(xdg-user-dir VIDEOS)" "$(HOME)/videos"; \
		xdg-user-dirs-update --set VIDEOS "$(HOME)/videos"; fi
	$(PRINT0) UPDATE "$(HOME)/www"
	$(QUIET) if [ "$$(xdg-user-dir PUBLICSHARE)" != "$(HOME)/www" ]; then \
		$(MV) "$$(xdg-user-dir PUBLICSHARE)" "$(HOME)/www"; \
		xdg-user-dirs-update --set PUBLICSHARE "$(HOME)/www"; fi
