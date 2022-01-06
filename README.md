# One Time Setup

Reference distribution: *Ubuntu 20.04*

## Basic System

### Configure `grub`

```bash
 sudo sed -i \
	-e '/^GRUB_SAVEDEFAULT/d' \
	-e 's/^GRUB_DEFAULT.*/GRUB_DEFAULT=saved/' \
	-e '/^GRUB_DEFAULT.*/a GRUB_SAVEDEFAULT=true' \
	/etc/default/grub

 sudo update-grub
```

### Configure `apt`

```bash
 sudo add-apt-repository universe
 sudo add-apt-repository multiverse
 sudo add-apt-repository restricted

 cat <<- EOF | sudo tee /etc/apt/apt.conf.d/60norecommend
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

 sudo apt update
```

### Remove `snapd`

```bash
 sudo rm -rf /var/cache/snapd/

 sudo apt autoremove --purge snapd gnome-software-plugin-snap

 rm -rf ${HOME}/snap/
```

### Region & Language

```bash
```

### Date & Time

```bash
```

### User directories

```bash
 for XDG_NAME_DIR in \
	DESKTOP:.desktop \
	DOCUMENTS:documents \
	DOWNLOAD:download \
	MUSIC:music \
	PICTURES:pictures \
	PUBLICSHARE:.public \
	TEMPLATES:.templates \
	VIDEOS:videos
 do
	XDG_NAME=${XDG_NAME_DIR%:*}
	XDG_DIR=${HOME%/}/${XDG_NAME_DIR#*:}
	XDG_CURRENT_DIR=$(xdg-user-dir ${XDG_NAME})

	if [ ${XDG_CURRENT_DIR} != ${XDG_DIR} ]
	then
		mv ${XDG_CURRENT_DIR} ${XDG_DIR}
		xdg-user-dirs-update --set ${XDG_NAME} ${XDG_DIR}
	fi
 done
```

### Configure `bash`

```bash
 sudo apt install --yes bash-completion

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc
https://github.com/jmlemetayer/one-time-setup/raw/main/.bash_logout
https://github.com/jmlemetayer/one-time-setup/raw/main/.profile
https://github.com/seebi/dircolors-solarized/raw/master/dircolors.ansi-dark
EOF

 mv /tmp/dircolors.ansi-dark /tmp/.dircolors

 install -m 640 -t ${HOME} \
	/tmp/.bashrc \
	/tmp/.bash_logout \
	/tmp/.profile \
	/tmp/.dircolors
```

### Configure `gpg`

```bash
 sudo apt install --yes scdaemon pcscd dirmngr

 printf "1\n" | gpg --command-fd 0 \
	--keyserver keyserver.ubuntu.com \
	--search-key jeanmarie.lemetayer@gmail.com

 printf "5\ny\n" | gpg --command-fd 0 \
	--edit-key 44188416362C8285005760B9E96A6F03E4526F5F trust

 mkdir -p ${HOME}/.config/autostart
 cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ${HOME}/.config/autostart/
 echo Hidden=true >> ${HOME}/.config/autostart/gnome-keyring-ssh.desktop
 echo enable-ssh-support > ~/.gnupg/gpg-agent.conf
```

### Install and configure `git`

```bash
 sudo apt install --yes git git-email

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.gitconfig
EOF

 install -m 640 -t ${HOME} \
	/tmp/.gitconfig
```

### Install and configure `vim`

```bash
 sudo apt install --yes vim

 rm -rf ${HOME}/.vim/

 git clone https://github.com/VundleVim/Vundle.vim.git \
	${HOME}/.vim/bundle/Vundle.vim

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.vimrc
EOF

 install -m 640 -t ${HOME} \
	/tmp/.vimrc

 vim +PluginInstall +qall
```

### Install and configure `tmux`

```bash
 sudo apt install --yes tmux

 rm -rf ${HOME}/.tmux/

 git clone https://github.com/tmux-plugins/tpm \
	${HOME}/.tmux/plugins/tpm

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.tmux.conf
EOF

 install -m 640 -t ${HOME} \
	/tmp/.tmux.conf

 tmux start-server
 tmux new-session -d
 sleep 1
 ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
 tmux kill-server
```

### Install and configure `sshd`

```bash
 sudo apt install --yes openssh-server

 sudo sed -i \
	-e 's|^#*\(HostKey .*\)|#\1|' \
	-e 's|^#\(HostKey /etc/ssh/ssh_host_ed25519_key\)|\1|' \
	-e 's|^#*\(PermitRootLogin \).*|\1no|' \
	-e 's|^#*\(PasswordAuthentication \).*|\1no|' \
	-e '/^Ciphers/d' \
	-e '/^# Ciphers and keying/a Ciphers chacha20-poly1305@openssh.com' \
	-e '/^KexAlgorithms/d' \
	-e '/^# Ciphers and keying/a KexAlgorithms curve25519-sha256@libssh.org' \
	-e '/^MACs/d' \
	-e '/^# Ciphers and keying/a MACs umac-128-etm@openssh.com' \
	-e '/^StreamLocalBindUnlink/d' \
	-e '$a StreamLocalBindUnlink yes' \
	/etc/ssh/sshd_config

 sudo rm -f /etc/ssh/ssh_host_*

 sudo dpkg-reconfigure openssh-server

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/authorized_keys
EOF

 install -m 750 -d ${HOME}/.ssh
 install -m 640 -t ${HOME}/.ssh \
	/tmp/authorized_keys
```

### Install and configure `python`

```bash
 sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
```

### Install and configure `docker`

```bash
 sudo apt install --yes \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common

 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

 sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

 sudo apt update
 sudo apt install --yes \
	containerd.io \
	docker-ce \
	docker-ce-cli \
	docker-compose

 sudo usermod -aG docker ${USER}
```

### Useful Tools

```bash
 sudo apt install --yes \
	bzip2 \
	curl \
	fd-find \
	htop \
	net-tools \
	ripgrep \
	sysstat \
	tree \
	unzip \
	xz-utils \
	zip
```

## Development Tools

### Development directory

```bash
 mkdir -p ${HOME}/development
```

### Essential Development Tools

```bash
 sudo apt install --yes \
	autoconf \
	automake \
	build-essential \
	clang \
	cmake \
	gdb \
	libncurses5-dev \
	libtool \
	minicom \
	pkg-config \
	python3 \
	tig \
	valgrind
```

### Configure `clang-format`

```bash
 sudo apt install --yes clang-format

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.clang-format
EOF

 install -m 640 -t ${HOME} \
	/tmp/.clang-format
```

### Install and configure `repo`

```bash
 wget -P /tmp -i - <<- EOF
https://storage.googleapis.com/git-repo-downloads/repo
https://github.com/aartamonau/repo.bash_completion/raw/master/repo.bash_completion
EOF

 sudo install -m 755 -t /usr/local/bin \
	/tmp/repo

 sudo install -m 644 -t /etc/bash_completion.d/ \
	/tmp/repo.bash_completion
```

## Desktop Only

### Gnome shell

```bash
 sudo apt install --yes vanilla-gnome-desktop
```

### Google Chrome

```bash
 wget -P /tmp -i - <<- EOF
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
EOF

 sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
```

### Install `git` graphical user interfaces

```bash
 sudo apt install --yes git-gui gitk
```

### Configure `vim` to use the clipboard

```bash
 sudo apt install --yes vim-gtk3
```
