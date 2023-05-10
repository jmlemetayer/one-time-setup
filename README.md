# One Time Setup

Reference distribution: *Ubuntu 22.04*

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
 sudo systemctl disable snapd.service
 sudo systemctl disable snapd.socket
 sudo systemctl disable snapd.seeded.service

 while [ -n "$(snap list 2>/dev/null)" ]
 do
	for SNAP in $(snap list | awk '!/^Name/ {print $1}')
	do
		sudo snap remove ${SNAP}
	done
 done

 sudo apt autoremove --yes --purge snapd

 sudo rm -rf /var/cache/snapd/
 rm -rf ${HOME}/snap/
```

See: https://onlinux.systems/guides/20220524_how-to-disable-and-remove-snap-on-ubuntu-2204

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
https://github.com/jmlemetayer/one-time-setup/raw/main/.ripgreprc
https://github.com/jmlemetayer/one-time-setup/raw/main/.tigrc
https://github.com/seebi/dircolors-solarized/raw/master/dircolors.ansi-dark
EOF

 mv /tmp/dircolors.ansi-dark /tmp/.dircolors

 install -m 640 -t ${HOME} \
	/tmp/.bashrc \
	/tmp/.bash_logout \
	/tmp/.profile \
	/tmp/.ripgreprc \
	/tmp/.tigrc \
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

 echo enable-ssh-support > ~/.gnupg/gpg-agent.conf

 cat <<- EOF | tee ${HOME}/.pam_environment
SSH_AGENT_PID DEFAULT=
SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
EOF

 mkdir -p ${HOME}/.config/autostart
 cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ${HOME}/.config/autostart/
 echo Hidden=true >> ${HOME}/.config/autostart/gnome-keyring-ssh.desktop
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
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/config
EOF

 install -m 750 -d ${HOME}/.ssh
 install -m 640 -t ${HOME}/.ssh \
	/tmp/config \
	/tmp/authorized_keys
```

### Install and configure `docker`

```bash
 sudo apt install --yes \
	ca-certificates \
	curl \
	gnupg \
	lsb-release

 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

 echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
	https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

 sudo apt update
 sudo apt install --yes \
	containerd.io \
	docker-ce \
	docker-ce-cli \
	docker-compose \
	docker-compose-plugin

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
	petname \
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
	direnv \
	gdb \
	libncurses5-dev \
	libtool \
	minicom \
	pkg-config \
	python3 \
	python3-pip \
	python3-venv \
	repo \
	tig \
	valgrind

 pip install pre-commit
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

### Install rust

```bash
 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
```

See: https://www.rust-lang.org/tools/install

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

### Install `keepass2` and the `KeeChallenge` plugin

```bash
 sudo apt install --yes keepass2 libykpers-1-1

 wget -P /tmp -i - <<- EOF
https://github.com/brush701/keechallenge/releases/download/1.5/KeeChallenge_1.5.zip
EOF

 sudo unzip /tmp/KeeChallenge_1.5.zip -d /usr/lib/keepass2/Plugins/
```

### Install `gpg2qr`, `qr2gpg` and `cam2gpg`

```bash
 sudo apt install -y \
	coreutils \
	gawk \
	gnupg \
	imagemagick \
	paperkey \
	qrencode \
	zbar-tools

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/gpg2qr/raw/master/cam2gpg
https://github.com/jmlemetayer/gpg2qr/raw/master/gpg2qr
https://github.com/jmlemetayer/gpg2qr/raw/master/qr2gpg
EOF

 sudo install -m 755 -t /usr/local/bin \
	/tmp/cam2gpg \
	/tmp/gpg2qr \
	/tmp/qr2gpg
```

### Install `klogg`

See: https://klogg.filimonov.dev/
