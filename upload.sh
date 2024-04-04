if [ $# -ne 2 ]; then
    echo -e "Usage: $0 <file-to-upload> <device>. \nParameter 1: Absolute path to upload file. For quick access \"rpi3\" or \"rpi4\" can be used, if you have them built.\nParameter 2: which /dev/sdX to upload to, e.g. \"./upload.sh rpi4 sda\"."
    exit 1
fi

# Enable specific filepaths and quick access to rpi3 and rpi4 directory
case $1 in
    rpi3)
        filepath=build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.wic.bz2
        ;;
    rpi4)
        filepath=build/tmp/deploy/images/raspberrypi4-64/core-image-full-cmdline-raspberrypi4-64.wic.bz2
        ;;
    *)
        filepath=$1
        ;;
esac

if [ ! -e $filepath ]; then
    echo "Could not find file at \"$filepath\", exiting ..."
    exit 1
fi

# Umounting device to enable bmaptools access.
device=$2
echo -e "\n» Attempting to umount /dev/${device}1, 2, 3 and 4"
umount /dev/${device}1 && umount /dev/${device}2 && umount /dev/${device}3 && umount /dev/${device}4
if [ $? -eq 0 ]; then
  echo "umount successful"
else
  echo "umount command failed."
fi

# Fire away
echo -e "\n» Copying build at \"$filepath\" to device \"/dev/$device\""
sudo bmaptool copy $filepath /dev/$device && sync

echo -e "\n» Finished script"