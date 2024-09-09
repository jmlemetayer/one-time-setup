> **One Time Setup** - One setup to rule them all

# Operating system installation

The reference distribution is *Debian*.

The following notation is used to categorized tasks:
- :desktop_computer: for desktop related tasks
- :toolbox: for development related tasks
- :shield: for security related tasks

## Debian stable minimal installation

The current Debian stable is the version 12 "bookworm".

A bootable USB key can be created using the "network install" or *netinst*.
The ISO can be downloaded here: https://www.debian.org/CD/netinst/

Boot on the USB key using UEFI, select the non graphical installer and use the
following configuration:

 - Default language: `English`
 - Location: `other/Europe/France`
 - Locales: `en_US.UTF-8`
 - Keyboard: `American English`
 - Network: use the first non wireless interface
 - Hostname: *your choice*
 - Domain name: *your choice*
 - Root password: leave it empty
 - Full name and username for the new user: *your choice*
 - Password for the new user: *your choice*
 - Partition disks: `Guided - use entire disk` then select *your disk*
 - Partitioning scheme: `All files in one partition` and validate the changes
 - Debian mirror: `France/deb.debian.org` without proxy
 - Popularity contest: *your choice*
 - Software selection: nothing

## Move to Debian testing :toolbox:

If needed, the move to Debian testing must be done now.

1. Copy the original `sources.list` file:
   ```bash
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.orig
   ```
1. Edit the `sources.list` file:
   ```
   deb http://deb.debian.org/debian/ testing main non-free-firmware
   deb http://security.debian.org/debian-security/ testing-security main non-free-firmware
   ```
1. Clean the `apt` state informations:
   ```bash
    sudo rm -rf /var/lib/apt/lists/*
   ```
1. Update the new packages information:
   ```bash
    sudo apt update
   ```
1. Upgrade the distribution:
   ```bash
    sudo apt full-upgrade
   ```
1. Reboot the PC.

> [!NOTE]
> Testing helpers can be installed with:
> ```bash
>  sudo apt install -y apt-listbugs apt-listchanges
> ```
>
> However this seems to break the following `tasksel` commands.

## Add a desktop environment :desktop_computer:

Just run `sudo tasksel` and select: `Debian desktop environment` and `GNOME`.

The network configuration file must be updated when switching to a desktop
environment:
 - Copy the original `interfaces` file:
   ```bash
    sudo cp /etc/network/interfaces /etc/network/interfaces.orig
   ```
 - Edit the `interfaces` file and remove the primary network interface stuff so
   that it ends by:
   ```
   # The loopback network interface
   auto lo
   iface lo inet loopback
   ```

Finally reboot the PC.

## Add laptop utilities

When running on a laptop, some utilities can be added by selecting the `laptop`
task when running `sudo tasksel`.

# Minimal system installation

## Prerequisites

```bash
 sudo apt install --no-install-recommends --no-install-suggests -y \
    ca-certificates curl git wget

 for GROUP in adm systemd-journal; do
    sudo usermod -aG ${GROUP} ${USER}
 done
```

## Configure `grub`

```bash
 sudo sed -i \
    -e '/^GRUB_SAVEDEFAULT/d' \
    -e 's/^GRUB_DEFAULT.*/GRUB_DEFAULT=saved/' \
    -e '/^GRUB_DEFAULT.*/a GRUB_SAVEDEFAULT=true' \
    -e 's/^.*\(GRUB_DISABLE_OS_PROBER\)=.*$/\1=false/' \
    /etc/default/grub

 sudo update-grub
```

## Configure `apt`

```bash
 sudo rm -rf /var/lib/apt/lists/*

 cat <<EOF | sudo tee /etc/apt/apt.conf.d/60norecommend
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

 sudo apt update
```

## Configure `bash`

```bash
 sudo apt install -y bash bash-completion

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.profile
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/01-prompt.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/02-history.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/05-color.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/10-functions.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/20-aliases.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/30-completions.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/40-miscellaneous.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.bash_logout
https://github.com/seebi/dircolors-solarized/raw/master/dircolors.ansi-dark
EOF

 install -m 640 -t ${HOME} \
    /tmp/${USER}/.profile \
    /tmp/${USER}/.bashrc \
    /tmp/${USER}/.bash_logout

 install -Dm 640 -t ${HOME}/.bashrc.d \
    /tmp/${USER}/01-prompt.sh \
    /tmp/${USER}/02-history.sh \
    /tmp/${USER}/05-color.sh \
    /tmp/${USER}/10-functions.sh \
    /tmp/${USER}/20-aliases.sh \
    /tmp/${USER}/30-completions.sh \
    /tmp/${USER}/40-miscellaneous.sh

 install -m 640 /tmp/${USER}/dircolors.ansi-dark ${HOME}/.dircolors

 . ${HOME}/.bashrc
```

## Install and configure `vim`

```bash
 sudo apt install -y vim

 sudo update-alternatives --set editor /usr/bin/vim.basic

 rm -rf ${HOME}/.vim/

 curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.vimrc
EOF

 install -m 640 /tmp/${USER}/.vimrc ${HOME}/.vimrc

 vim +PlugInstall +qall
```

## Install and configure `tmux`

```bash
 sudo apt install -y tmux

 rm -rf ${HOME}/.tmux/

 git clone https://github.com/tmux-plugins/tpm \
    ${HOME}/.tmux/plugins/tpm

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.tmux.conf
EOF

 install -m 640 /tmp/${USER}/.tmux.conf ${HOME}/.tmux.conf

 TMUX_PLUGIN_MANAGER_PATH=${HOME}/.tmux/plugins \
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins
```

## Configure `ssh`

```bash
 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/authorized_keys
https://github.com/jmlemetayer/one-time-setup/raw/main/.ssh/config
EOF

 install -m 750 -d ${HOME}/.ssh
 install -m 640 -t ${HOME}/.ssh \
    /tmp/${USER}/config \
    /tmp/${USER}/authorized_keys
```

## Install and configure `sshd`

```bash
 sudo apt install -y openssh-server

 cat <<EOF | sudo tee /etc/ssh/sshd_config.d/${HOSTNAME}.conf
Port 6942

HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
Ciphers chacha20-poly1305@openssh.com
KexAlgorithms curve25519-sha256@libssh.org
MACs umac-128-etm@openssh.com

# Authentication
PermitRootLogin no
PasswordAuthentication no

# Forwarding
StreamLocalBindUnlink yes

# Do not allow the client to pass locale environment variables
AcceptEnv no
EOF

 sudo sed -i \
    -e 's|^#*\(AcceptEnv .*\)|#\1|' \
    /etc/ssh/sshd_config

 sudo rm -f /etc/ssh/ssh_host_*
 sudo dpkg-reconfigure openssh-server
```

## User directories :desktop_computer: :toolbox:

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

    if [ ${XDG_CURRENT_DIR} != ${XDG_DIR} ]; then
        mv ${XDG_CURRENT_DIR} ${XDG_DIR}
        xdg-user-dirs-update --set ${XDG_NAME} ${XDG_DIR}
    fi
 done

 mkdir -p ${HOME}/development
```

## Install compression packages

```bash
 sudo apt install -y \
    bzip2 \
    gzip \
    tar \
    unzip \
    xz-utils \
    zip \
    zstd
```

## Install system packages

```bash
 sudo apt install -y \
    bind9-dnsutils \
    htop \
    net-tools \
    tree
```

# Extra applications and development tools

## Configure `gpg` :desktop_computer: :toolbox: :shield:

```bash
 sudo apt install -y gnupg pcscd scdaemon

 printf "1\n" | gpg --command-fd 0 \
    --keyserver keyserver.ubuntu.com \
    --search-key jeanmarie.lemetayer@gmail.com

 printf "5\ny\n" | gpg --command-fd 0 \
    --edit-key 44188416362C8285005760B9E96A6F03E4526F5F trust

 echo enable-ssh-support > ~/.gnupg/gpg-agent.conf

 cat <<EOF | tee ${HOME}/.pam_environment
SSH_AGENT_PID DEFAULT=
SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
EOF

 mkdir -p ${HOME}/.config/autostart
 cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ${HOME}/.config/autostart/
 echo Hidden=true >> ${HOME}/.config/autostart/gnome-keyring-ssh.desktop

 for SUFFIX in service socket; do
    systemctl --user stop gcr-ssh-agent.${SUFFIX}
    systemctl --user disable gcr-ssh-agent.${SUFFIX}
    sudo systemctl --global disable gcr-ssh-agent.${SUFFIX}
 done
```

## Install and configure `git` :toolbox:

```bash
 sudo apt install -y git tig

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.gitconfig
https://github.com/jmlemetayer/one-time-setup/raw/main/.tigrc
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/50-git.sh
EOF

 install -m 640 -t ${HOME} \
    /tmp/${USER}/.gitconfig \
    /tmp/${USER}/.tigrc

 install -Dm 640 /tmp/${USER}/50-git.sh ${HOME}/.bashrc.d/50-git.sh

 . ${HOME}/.bashrc
```

## Install the rust toolchain :toolbox:

```bash
 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path

 mkdir -p ${HOME}/.local/share/bash-completion/completions
 rustup completions bash \
    >> ${HOME}/.local/share/bash-completion/completions/rustup
 rustup completions bash cargo \
    >> ${HOME}/.local/share/bash-completion/completions/cargo

 rustup component add rust-analyzer

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/55-rust.sh
EOF

 install -Dm 640 /tmp/${USER}/55-rust.sh ${HOME}/.bashrc.d/55-rust.sh

 . ${HOME}/.bashrc
```

## Install `docker`

```bash
 sudo install -m 755 -d /etc/apt/keyrings
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
 sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

 sudo usermod -aG docker ${USER}
```

## Install `podman` :toolbox:

```bash
 sudo apt install -y podman slirp4netns uidmap passt
```

## Install development packages :toolbox:

```bash
 sudo apt install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    clang \
    cmake \
    flex \
    gdb \
    gettext \
    libncurses5-dev \
    libtool \
    manpages-dev \
    pkg-config \
    pre-commit \
    python-is-python3 \
    python3 \
    python3-pip \
    shellcheck \
    shfmt \
    valgrind
```

## Install `repo` :toolbox:

```bash
 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://storage.googleapis.com/git-repo-downloads/repo
EOF

 sudo install -Dm 755 /tmp/${USER}/repo /usr/local/bin/repo

 curl "https://gerrit.googlesource.com/git-repo/+/refs/heads/main/completion.bash?format=TEXT" \
    | base64 --decode > /tmp/${USER}/completion.bash

 sudo install -Dm 644 /tmp/${USER}/completion.bash /usr/share/bash-completion/completions/repo
```

## Install and configure `clang-format` :toolbox:

```bash
 sudo apt install -y clang-format

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.clang-format
EOF

 install -m 640 /tmp/${USER}/.clang-format ${HOME}/.clang-format
```

## Install `direnv` :toolbox:

```bash
 sudo apt install -y direnv python3-venv

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/60-direnv.sh
EOF

 install -Dm 640 /tmp/${USER}/60-direnv.sh ${HOME}/.bashrc.d/60-direnv.sh

 . ${HOME}/.bashrc
```

## Install `minicom` :toolbox:

```bash
 sudo apt install -y minicom

 sudo usermod -aG dialout ${USER}

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/61-minicom.sh
EOF

 install -Dm 640 /tmp/${USER}/61-minicom.sh ${HOME}/.bashrc.d/61-minicom.sh

 . ${HOME}/.bashrc
```

## Install `fd` :toolbox:

```bash
 cargo install fd-find
 strip ${HOME}/.cargo/bin/fd
 sudo install -m 755 ${HOME}/.cargo/bin/fd /usr/local/bin/fd
 cargo uninstall fd-find
```

## Install and configure `rg` :toolbox:

```bash
 cargo install ripgrep
 strip ${HOME}/.cargo/bin/rg
 sudo install -m 755 ${HOME}/.cargo/bin/rg /usr/local/bin/rg
 cargo uninstall ripgrep

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/62-ripgrep.sh
https://github.com/jmlemetayer/one-time-setup/raw/main/.ripgreprc
EOF

 install -m 640 /tmp/${USER}/.ripgreprc ${HOME}/.ripgreprc

 install -Dm 640 /tmp/${USER}/62-ripgrep.sh ${HOME}/.bashrc.d/62-ripgrep.sh

 . ${HOME}/.bashrc
```

## Install `gitlabci-local` :toolbox:

```bash
 pip install --break-system-packages -U gitlabci-local

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/63-gitlabci-local.sh
EOF

 install -Dm 640 /tmp/${USER}/63-gitlabci-local.sh ${HOME}/.bashrc.d/63-gitlabci-local.sh

 . ${HOME}/.bashrc
```

## Configure openbar based projects :toolbox:

```bash
 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/one-time-setup/raw/main/.bashrc.d/70-openbar.sh
EOF

 install -Dm 640 /tmp/${USER}/70-openbar.sh ${HOME}/.bashrc.d/70-openbar.sh

 . ${HOME}/.bashrc
```

# Setting up the desktop environment

## Install the Ubuntu Mono Nerd font :desktop_computer: :toolbox:

```bash
 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
EOF

 sudo unzip /tmp/${USER}/UbuntuMono.zip *.ttf -d /usr/local/share/fonts/
 sudo chmod 644 /usr/local/share/fonts/UbuntuMono*.ttf
 sudo fc-cache
```

## Install and configure `alacritty` :desktop_computer: :toolbox:

```bash
 sudo apt install -y \
    libfontconfig1-dev \
    libfreetype6-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev

 cargo install alacritty
 strip ${HOME}/.cargo/bin/alacritty
 sudo install -m 755 ${HOME}/.cargo/bin/alacritty /usr/local/bin/alacritty
 cargo uninstall alacritty

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/alacritty/alacritty/releases/latest/download/alacritty.bash
https://github.com/alacritty/alacritty/releases/latest/download/alacritty.info
https://github.com/alacritty/alacritty/releases/latest/download/Alacritty.svg
https://github.com/alacritty/alacritty/releases/latest/download/Alacritty.desktop
https://github.com/jmlemetayer/one-time-setup/raw/main/.config/alacritty/alacritty.toml
EOF

 sudo install -Dm 644 /tmp/${USER}/alacritty.bash /usr/share/bash-completion/completions/alacritty

 sudo tic -xe alacritty,alacritty-direct /tmp/${USER}/alacritty.info

 sudo install -Dm 644 /tmp/${USER}/Alacritty.svg /usr/share/pixmaps/Alacritty.svg
 sudo desktop-file-install /tmp/${USER}/Alacritty.desktop
 sudo update-desktop-database

 rm -rf ${HOME}/.config/alacritty

 mkdir -p ${HOME}/.config/alacritty/themes
 git clone https://github.com/alacritty/alacritty-theme ${HOME}/.config/alacritty/themes

 install -Dm 640 /tmp/${USER}/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml
```

## Install `git` graphical user interfaces :desktop_computer: :toolbox:

```bash
 sudo apt install -y git-gui gitk
```

## Install Google Chrome :desktop_computer:

```bash
 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
EOF

 sudo dpkg -i /tmp/${USER}/google-chrome-stable_current_amd64.deb
 sudo apt install -f -y
```

## Install `keepass2` and the `KeeChallenge` plugin :desktop_computer: :shield:

```bash
 sudo apt install -y keepass2 libykpers-1-1

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/brush701/keechallenge/releases/download/1.5/KeeChallenge_1.5.zip
EOF

 sudo unzip /tmp/${USER}/KeeChallenge_1.5.zip -d /usr/lib/keepass2/Plugins/
```

## Install `gpg2qr`, `qr2gpg` and `cam2gpg` :desktop_computer: :shield:

```bash
 sudo apt install -y \
    coreutils \
    gawk \
    gnupg \
    imagemagick \
    paperkey \
    qrencode \
    zbar-tools

 wget --backups=0 -P /tmp/${USER} -i - <<EOF
https://github.com/jmlemetayer/gpg2qr/raw/master/cam2gpg
https://github.com/jmlemetayer/gpg2qr/raw/master/gpg2qr
https://github.com/jmlemetayer/gpg2qr/raw/master/qr2gpg
EOF

 sudo install -m 755 -t /usr/local/bin \
    /tmp/${USER}/cam2gpg \
    /tmp/${USER}/gpg2qr \
    /tmp/${USER}/qr2gpg
```
