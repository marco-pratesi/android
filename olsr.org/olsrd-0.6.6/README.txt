
olsrd-NOTES-0.6.6.txt
---------------------
How to build and install olsrd.

olsrd-0.6.6-android-conf_file_path.patch
----------------------------------------
Change the default configuration file.

olsrd-0.6.6-android-ndk_platform_level.patch
--------------------------------------------
Change the NDK_PLATFORM_LEVEL for the cross-compilation.

olsrd-0.6.6-android-quagga.patch
--------------------------------
* Enable build of the Quagga plugin.
* Change the default ZEBRA_SOCKPATH to match
  the Android filesystem and the choice made for Quagga
  (see the pertinent section of the repository).

olsrd-0.6.6-android-simple.conf
-------------------------------
Simple configuration file, with an example of usage of the Quagga plugin
(commented out).

