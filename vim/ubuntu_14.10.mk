#
# Vim setup rules
#

# Vim colors for solarized theme
VIM_SOLARIZED_URL := https://github.com/altercation/solarized/raw/master/vim-colors-solarized/colors/solarized.vim
VIM_SOLARIZED := solarized.vim
VIM_HTML5_URL := https://github.com/othree/html5.vim/archive/master.tar.gz
VIM_HTML5 := html5.vim-master
VIM_AUTOFORMAT_URL := https://github.com/Chiel92/vim-autoformat/archive/master.tar.gz
VIM_AUTOFORMAT := vim-autoformat-master

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
	$(QUIET) $(S_PACKAGE) install vim astyle
ifeq ($(MACHINE_TYPE), desktop)
	$(QUIET) $(S_PACKAGE) install vim-gnome
endif
endif
	$(PRINT1) CONFIG "$@"
	$(PRINT0) MKDIR "$(HOME)/.vim/backup"
	$(QUIET) $(MKDIR) $(HOME)/.vim/backup
	$(PRINT0) COPY "$(HOME)/.vimrc"
	$(QUIET) $(CP) vim/vimrc $(HOME)/.vimrc
	$(PRINT0) WGET "$(VIM_HTML5)"
	$(QUIET) $(WGET) /tmp/$(VIM_HTML5).tar.gz $(VIM_HTML5_URL)
	$(PRINT0) EXTRACT "$(VIM_HTML5)"
	$(QUIET) tar xzf /tmp/$(VIM_HTML5).tar.gz -C /tmp
	$(PRINT0) INSTALL "$(VIM_HTML5)"
	$(QUIET) $(MAKE) -s -C /tmp/$(VIM_HTML5) install >/dev/null 2>/dev/null
	$(QUIET) $(RM) -r /tmp/$(VIM_HTML5)*
	$(PRINT0) UPDATE "$(HOME)/.vimrc"
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) cat vim/vimrc.html5 >> $(HOME)/.vimrc
	$(PRINT0) WGET "$(VIM_AUTOFORMAT)"
	$(QUIET) $(WGET) /tmp/$(VIM_AUTOFORMAT).tar.gz $(VIM_AUTOFORMAT_URL)
	$(PRINT0) EXTRACT "$(VIM_AUTOFORMAT)"
	$(QUIET) tar xzf /tmp/$(VIM_AUTOFORMAT).tar.gz -C /tmp
	$(PRINT0) INSTALL "$(VIM_AUTOFORMAT)"
	$(QUIET) $(MKDIR) $(HOME)/.vim/plugin
	$(QUIET) mv /tmp/$(VIM_AUTOFORMAT)/plugin/autoformat.vim $(HOME)/.vim/plugin
	$(QUIET) mv /tmp/$(VIM_AUTOFORMAT)/plugin/defaults.vim $(HOME)/.vim/plugin
	$(QUIET) $(RM) -r /tmp/$(VIM_AUTOFORMAT)*
	$(PRINT0) UPDATE "$(HOME)/.vimrc"
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) cat vim/vimrc.autoformat.ubuntu_14.10 >> $(HOME)/.vimrc
ifeq ($(CONFIG_THEME), $(filter $(CONFIG_THEME), solarized-dark solarized-light))
	$(PRINT0) MKDIR "$(HOME)/.vim/colors"
	$(QUIET) $(MKDIR) $(HOME)/.vim/colors
	$(PRINT0) WGET "$(HOME)/.vim/colors/$(VIM_SOLARIZED)"
	$(QUIET) $(WGET) $(HOME)/.vim/colors/$(VIM_SOLARIZED) $(VIM_SOLARIZED_URL)
	$(PRINT0) UPDATE "$(HOME)/.vimrc"
	$(QUIET) echo >> $(HOME)/.vimrc
	$(QUIET) cat vim/vimrc.$(CONFIG_THEME) >> $(HOME)/.vimrc
else
	$(PRINT0) RM "$(HOME)/.vim/colors"
	$(QUIET) $(RM) -r $(HOME)/.vim/colors
endif
