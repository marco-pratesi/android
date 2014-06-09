
picocom-1.7-android-build-HOWTO.txt
-----------------------------------
How to build and install picocom.

picocom-1.7-android.patch
-------------------------
* Change the UUCP_LOCK_DIR to match the Android filesystem.
* Replace tcdrain(), not available in Bionic, with ioctl().

