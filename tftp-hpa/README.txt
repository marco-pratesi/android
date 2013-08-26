
tftp-hpa-NOTES-5.2.txt
----------------------
How to build tftp-hpa and tftpd-hpa.

tftp-hpa-5.2-android.patch
--------------------------
* Use arpa/tftp.h from glibc, as it is not available in Bionic.
* Add definitions of S_IWRITE and S_IREAD, taken from glibc.

