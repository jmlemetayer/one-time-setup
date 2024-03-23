# One Time Setup

Reference distribution: *Debian testing (from Debian 12)*

## Basic System

### Configure `grub`

```bash
 sudo sed -i \
    -e '/^GRUB_SAVEDEFAULT/d' \
    -e 's/^GRUB_DEFAULT.*/GRUB_DEFAULT=saved/' \
    -e '/^GRUB_DEFAULT.*/a GRUB_SAVEDEFAULT=true' \
    -e 's/^.*\(GRUB_DISABLE_OS_PROBER\)=.*$/\1=false/' \
    /etc/default/grub

 sudo update-grub
```

### Configure `apt`

```bash
 sudo rm -rf /var/lib/apt/lists/*

 cat <<- EOF | sudo tee /etc/apt/apt.conf.d/60norecommend
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

 sudo apt update
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

 mkdir -p ${HOME}/development
```

### Required tools

```bash
 sudo apt install --yes ca-certificates curl wget
```

### Configure `bash`

```bash
 sudo apt install --yes bash bash-completion

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
 sudo apt install --yes gnupg pcscd scdaemon

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

 sudo update-alternatives --set editor /usr/bin/vim.basic
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

### Configure `ssh`

```bash
 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/authorized_keys
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/config
EOF

 install -m 750 -d ${HOME}/.ssh
 install -m 640 -t ${HOME}/.ssh \
    /tmp/config \
    /tmp/authorized_keys
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
```

### Install and configure `docker`

```bash
 sudo install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 sudo chmod a+r /etc/apt/keyrings/docker.gpg

 echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

 sudo sed -i 's/trixie/bookworm/' /etc/apt/sources.list.d/docker.list

 sudo apt update
 sudo apt install --yes \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

 sudo usermod -aG docker ${USER}
```

See: https://docs.docker.com/engine/install/debian/

### Install rust

```bash
 sudo apt install --yes rustup
 rustup default stable
```

See: https://www.rust-lang.org/tools/install

### Useful Tools

#### Compression

```bash
 sudo apt install --yes \
    bzip2 \
    gzip \
    tar \
    unzip \
    xz-utils \
    zip \
    zstd
```

#### System

```bash
 sudo apt install --yes \
    direnv \
    htop \
    minicom \
    net-tools \
    tree
```

#### Development

```bash
 sudo apt install --yes \
    autoconf \
    automake \
    build-essential \
    clang \
    cmake \
    libncurses5-dev \
    libtool \
    pkg-config \
    pre-commit \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    tig \
    valgrind

 cargo install fd-find
 cargo install ripgrep && strip $(which rg)

 wget -P /tmp -i - <<- EOF
https://storage.googleapis.com/git-repo-downloads/repo
EOF

 sudo install -m 755 -t /usr/local/bin /tmp/repo
```

### Configure `clang-format`

```bash
 sudo apt install --yes clang-format

 wget -P /tmp -i - <<- EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.clang-format
EOF

 install -m 640 -t ${HOME} /tmp/.clang-format
```

## Desktop Only

### Google Chrome

```bash
 wget -P /tmp -i - <<- EOF
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
EOF

 sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
 sudo apt install -f --yes
```

See: https://www.google.com/chrome/

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

```bash
 curl -sS https://klogg.filimonov.dev/klogg.gpg.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/klogg.gpg

 curl -sS https://klogg.filimonov.dev/deb/klogg.jammy.list | \
    sudo tee /etc/apt/sources.list.d/klogg.list

 sudo apt update
 sudo apt install --yes klogg
```

See: https://klogg.filimonov.dev/
