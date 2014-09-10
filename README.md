# One Time Setup [![Build Status][1]][2]

This _one time setup_ allows you to set up your environment as quickly as
possible. You can also improve this setup by adding your [modules][3].

## How to install

To configure and install the _one time setup_, even after a fresh install,
this is as easy as:

	sh <(wget -q -O - http://git.io/one-time-setup)

Or the long version:

	sh <(wget -q -O - https://github.com/jmlemetayer/one-time-setup/raw/master/one-time-setup)

You can also download the tarball and configure the setup by yourself:

	wget https://github.com/jmlemetayer/one-time-setup/archive/master.tar.gz
	tar xzf master.tar.gz
	cd one-time-setup-master
	cp defconfig .config
	vi .config
	make

## Supported linux distribution

This _one time setup_ has been tested on:

 * [ubuntu-14.04-server][5]
 * [ubuntu-14.04-desktop][5]
 * [ubuntu-gnome-14.04-desktop][6]

If you want to try it on a new distribution which has not been tested yet,
just run the `Makefile` manually with the force option: `make F=1`.
If it is straightforward, just add the distribution in the supported list.
Else you have to add some [makefiles][3] to support it.

## License

This work is [unlicensed][4].

[1]: https://travis-ci.org/jmlemetayer/one-time-setup.png?branch=master
[2]: https://travis-ci.org/jmlemetayer/one-time-setup
[3]: https://github.com/jmlemetayer/one-time-setup/wiki/Module
[4]: http://unlicense.org "Unlicense"
[5]: http://releases.ubuntu.com/14.04/
[6]: http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.04/release/
