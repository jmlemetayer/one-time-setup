# One Time Setup

Reference distribution: *Ubuntu 20.04*

## Basic System

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

cat << EOF | sudo tee /etc/apt/apt.conf.d/60norecommend
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

sudo apt update
```

### Configure `bash`

```bash
sudo apt install bash-completion

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.bashrc
https://github.com/jmlemetayer/one-time-setup/raw/master/.bash_logout
https://github.com/jmlemetayer/one-time-setup/raw/master/.profile
https://github.com/seebi/dircolors-solarized/raw/master/dircolors.ansi-dark
EOF

mv /tmp/dircolors.ansi-dark /tmp/.dircolors

install -m 640 -t ${HOME} \
    /tmp/.bashrc \
    /tmp/.bash_logout \
    /tmp/.profile \
    /tmp/.dircolors
```

### Install and configure `vim`

```bash
sudo apt install vim

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

### Install and configure `git`

```bash
sudo apt install git

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.gitconfig
EOF

install -m 640 -t ${HOME} \
    /tmp/.gitconfig
```

### Configure `gpg`

```bash
sudo apt install scdaemon pcscd dirmngr

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

### Install and configure `tmux`

```bash
sudo apt install tmux

rm -rf ${HOME}/.tmux/

git clone https://github.com/tmux-plugins/tpm \
    ${HOME}/.tmux/plugins/tpm

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.tmux.conf
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
sudo apt install openssh-server

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

### Useful Tools

```bash
sudo apt install \
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

### Development packages

```bash
```

### Configure `clang-format`

```bash
sudo apt install clang-format

wget -P /tmp -i - << EOF
https://github.com/jmlemetayer/one-time-setup/raw/master/.clang-format
EOF

install -m 640 -t ${HOME} \
    /tmp/.clang-format
```

## Desktop Only

### Gnome shell

```bash
sudo apt install vanilla-gnome-desktop
```

### Google Chrome

```bash
wget -P /tmp -i - << EOF
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
EOF

sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
```

### Configure `vim` to use the clipboard

```bash
sudo apt install vim-gtk3
```
