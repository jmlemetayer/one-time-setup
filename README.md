# One Time Setup

## Region & Language

```bash
```

## Date & Time

```bash
```

## Configure `apt`

```bash
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo add-apt-repository restricted

cat << EOF | sudo tee /etc/apt/apt.conf.d/60norecommend
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

sudo apt update
```

## Configure `grub`

```bash
sudo sed -i \
	-e '/^GRUB_SAVEDEFAULT/d' \
	-e 's/^GRUB_DEFAULT.*/GRUB_DEFAULT=saved/' \
	-e '/^GRUB_DEFAULT.*/a GRUB_SAVEDEFAULT=true' \
	/etc/default/grub

sudo update-grub
```

## Common packages

```bash
```

## Gnome shell (for desktop only)

```bash
sudo apt install vanilla-gnome-desktop
```

## SSH server

```bash
```

## Development packages

```bash
```

## User directories

```bash
```

## Configure `bash`

```bash
wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.bashrc
https://github.com/jmlemetayer/one-time-setup/raw/master/.bash_logout
https://github.com/jmlemetayer/one-time-setup/raw/master/.profile
https://github.com/seebi/dircolors-solarized/raw/master/dircolors.256dark
EOF

mv /tmp/dircolors.256dark /tmp/.dircolors

install -m 640 -t ${HOME} \
	/tmp/.bashrc \
	/tmp/.bash_logout \
	/tmp/.profile \
	/tmp/.dircolors
```

## Configure `git`

```bash
sudo apt install git

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.gitconfig
EOF

install -m 640 -t ${HOME} \
	/tmp/.gitconfig
```

## Configure `clang-format`

```bash
sudo apt install clang-format

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.clang-format
EOF

install -m 640 -t ${HOME} \
	/tmp/.clang-format
```

## Configure `vim`

```bash
sudo apt install vim

# For desktop only
sudo apt install vim-gtk

rm -rf ${HOME}/.vim/

git clone https://github.com/VundleVim/Vundle.vim.git \
	${HOME}/.vim/bundle/Vundle.vim

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.vimrc
EOF

install -m 640 -t ${HOME} \
	/tmp/.vimrc

vim +PluginInstall +qall
```

## Configure `tmux`

```bash
```

## Configure `gpg`

```bash
```
