
quagga-NOTES-0.99.22.1.txt
--------------------------
How to build and install quagga.

quagga-0.99.21-android.patch
----------------------------
* Disable password encryption in the configuration file:
  the crypt() function is available in standard libc implementations,
  but is not in the Android's Bionic.
* Adjust the path for inclusion of a .h file.

