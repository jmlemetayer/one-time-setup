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
```

## Configure `git`

```bash
```

## Configure `clang-format`

```bash
```

## Configure `vim`

```bash
```

## Configure `tmux`

```bash
```

## Configure `gpg`

```bash
```
