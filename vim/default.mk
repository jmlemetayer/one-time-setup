#
# Vim setup rules
#

# Vim colors for solarized theme
VIM_SOLARIZED := https://github.com/altercation/solarized/raw/master/vim-colors-solarized/colors/solarized.vim
VIM_HTML5 := https://github.com/othree/html5.vim/archive/master.tar.gz

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
	$(PRINT0) WGET "html5.vim-master.tar.gz"
	$(QUIET) $(WGET) /tmp/html5.vim-master.tar.gz $(VIM_HTML5)
	$(PRINT0) EXTRACT "html5.vim-master.tar.gz"
	$(QUIET) tar xzf /tmp/html5.vim-master.tar.gz -C /tmp
	$(PRINT0) INSTALL "html5.vim-master"
	$(QUIET) $(MAKE) -s -C /tmp/html5.vim-master install >/dev/null 2>/dev/null
	$(QUIET) $(RM) -r /tmp/html5.vim-master*
	$(PRINT0) UPDATE "$(HOME)/.vimrc"
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) cat vim/vimrc.html5 >> $(HOME)/.vimrc
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
