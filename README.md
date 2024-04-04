# Yocto linux image for Raspberry Pi CM4

## Purpose of repository
This is a minimal version of a yocto build, to test compatibility of new projects before adding them to the main repo.
Currently focused on:
* Hailo AI chip

## Clone / Initialize this repository

There are two ways of initializing this repository:
* Clone this repository with "git clone --recursive".

or

* Run "git clone" and then "git submodule update --init --recursive". This will
bring in all the needed dependencies.

## Build information

### Build Dependencies

* Ubuntu and Debian

```
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm
```

### Build this repository

The script available in `build.sh` can be used as a convenience layer around the following steps:

* Prepare build's shell environment
    ```bash
    $ TEMPLATECONF=$(pwd)/conf/samples source layers/poky/oe-init-build-env
    ```

* Run bitbake
    ```bash
    $ bitbake update-image
    ```

* If all goes well, you will now have a custom image available at (assuming `cwd = build`)

    ```bash
    $ ls build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.wic.bz2
    ```

* This image can be flashed using you favourite tools, e.g. (replace `/dev/sdX` with appropriate path)

    - (preferred) `sudo bmaptool copy build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.wic.bz2 /dev/sdX`
    - `bzcat build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.wic.bz2 | sudo dd bs=4M of=/dev/sdX && sync`
