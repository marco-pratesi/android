
tftp-hpa-5.2-android-cross_build-HOWTO.txt
------------------------------------------
How to build tftp-hpa and tftpd-hpa for Android through the NDK cross-compiler
and install them.

tftp-hpa-5.2-android-native_build-HOWTO.txt
-------------------------------------------
How to build tftp-hpa and tftpd-hpa through a native GCC for Android
( https://github.com/marco-pratesi/android/tree/master/gcc_and_friends )
and install them.

tftp-hpa-5.2-android-cross_build.patch and
tftp-hpa-5.2-android-native_build.patch
------------------------------------------
* Use the arpa/tftp.h taken from glibc, as it is not available in Bionic.
* Add definitions of S_IWRITE and S_IREAD, taken from glibc.

tftp-hpa-5.2-android-example_of_usage.txt
-----------------------------------------
An example of usage of tftpd-hpa on Android.

