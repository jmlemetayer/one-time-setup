One Time Setup
==============

This is my "one time setup". You can easily use it for your own setup by editing
rules or just edit your own configuration.

### Download

To get it, you can do this:

	wget http://github.com/jmlemetayer/one-time-setup/archive/master.tar.gz
	tar xzf master.tar.gz

Or this:

	sudo apt-get update
	sudo apt-get install git-core
	git clone git://github.com/jmlemetayer/one-time-setup.git

### Install

Fisrt, you have to install make:

	sudo apt-get update
	sudo apt-get install make

Then you can edit your configuration file:

	cd one-time-setup
	cp defconfig .config
	vi .config

And finally run:

	make

### License

This work is [unlicensed][1].

[1]: http://unlicense.org "Unlicense"
