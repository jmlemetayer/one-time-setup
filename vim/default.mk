#
# Vim setup rules
#

# Vim colors for solarized theme
VIM_SOLARIZED := https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim

# Add vim into the target list
PHONY += vim

ifdef CONFIG_VIM
all: vim
endif

# Define the vim target
vim: package-update
ifeq ($(MACHINE_ACCESS), admin)
	$(PRINT1) INSTALL "$@"
	$(PRINT0) PACKAGE "$@"
ifeq ($(MACHINE_TYPE), server)
	$(QUIET) $(S_PACKAGE) install vim
else
	$(QUIET) $(S_PACKAGE) install vim vim-gnome
endif
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) MKDIR "$(HOME)/.vim/backup"
	$(QUIET) $(MKDIR) $(HOME)/.vim/backup
	$(PRINT0) COPY "$(HOME)/.vimrc"
	$(QUIET) $(CP) vim/vimrc $(HOME)/.vimrc
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(PRINT0) MKDIR "$(HOME)/.vim/colors"
	$(QUIET) $(MKDIR) $(HOME)/.vim/colors
	$(PRINT0) WGET "$(HOME)/.vim/colors/solarized.vim"
	$(QUIET) $(WGET) $(HOME)/.vim/colors/solarized.vim $(VIM_SOLARIZED)
	$(PRINT0) UPDATE "$(HOME)/.vimrc"
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) cat vim/vimrc.$(CONFIG_THEME) >> $(HOME)/.vimrc
else
	$(PRINT0) RM "$(HOME)/.vim/colors"
	$(QUIET) $(RM) -r $(HOME)/.vim/colors
endif
