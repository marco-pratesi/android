
vim-7.4-android-cross_build-HOWTO.txt provides instructions to cross-build
  and install VIM for Android.
vim-7.4-android-cross_build.patch is the patch referenced in instructions
  to cross-build VIM.
vim-7.3-android-cross_build.patch: you should not need this
  (read vim-7.4-android-cross_build-HOWTO.txt).
vim-7.4-android-native_build-HOWTO.txt provides instructions to build VIM
  through a native GCC for Android
  ( https://github.com/marco-pratesi/android/tree/master/gcc_and_friends )
  and install it.
vim-7.4-android-native_build.patch is the patch referenced in instructions
  for the native build.
vimrc-android: my favourite vimrc for Android.
screenshots/ : in this directory, you can find some screenshots :-)

Some explanations are needed to understand the rationale behind all parts
of the patches and to describe the directory structures I have chosen.

Cross-compiling VIM for Android is not so difficult.
I only found a problem building it with multibyte support, as Bionic
does not provide mblen(); in src/mbyte.c I added __BIONIC__ to the list
of platforms where mblen() is not available; maybe this is not the best
solution, suggestions are welcome.
Anyway, I did not work so much on this issue, as I suspect that remaining
problems in multibyte support are due to the underlying environment:
as an example, try to type and delete some italian accented letters
on the shell prompt on the Android Terminal and on the ADB shell,
to understand what I mean.

Apart from the only build stopper, i.e. the lack of mblen(),
I faced some problems related to paths and environment variables.

The simpler problem: system executables (e.g. "sh") are not
in /bin and /usr/bin, but in /system/bin and /system/xbin; I just found
affected files and edited paths accordingly.

Worse problems are related to $HOME, /tmp, /var/tmp.
On whatever Unix system I put my hands, both the root and an unprivileged
user can enter the $HOME dir and create/delete/edit files in it; hence,
IMHO, in the VIM code, the assumption that the program can create/delete/edit
files in $HOME is absolutely reasonable.
As it is usually said, "there is no place like $HOME", but, alas,
this is not true for androids :-)
Based on the few devices I played with, you cannot be sure about the value
of the HOME env var: it can be the root dir ("/"), or maybe the /data dir.
Even if you are the root user, you can not write in the / dir,
as a file system is mounted there in read-only mode, for security reasons;
if you have root privileges, you can remount it as read/write,
but assuming that it has to stay mounted as read/write when you want
to be able to use VIM (i.e. almost always :-)) is not a reasonable choice.
The problem is less severe if the $HOME dir is /data, whose file system
is mounted as read/write, so that the root user can play with this dir;
but an unprivileged user can not.
I can not overcome the "rooted device" requirement: the unprivileged user
can write files in /sdcard only, but files placed there cannot be executed;
however, whenever possible, I want that root privileges are only needed
to install packages, and that the unprivileged user can run them.
Similar considerations can be drawn about /tmp and /var/tmp: they are not
available on Android and, AFAIK, no other equivalent temporary dir is
available for the unprivileged user, too.

Hence, I based my decisions on the following facts:
- I cannot rely on the $HOME dir
- the VIM code widely refers to the $HOME dir
- I do not want to patch too much code, as
  * I am lazy :-)
  * the more the code I write/patch, the more the bugs I may add :-)
  * maintaining larger patches is more difficult
- the only directories I can rely on are /sdcard for unprivileged users,
  and /data, too, for the root user
- alas, file/dir owners/groups/permissions are not reliable on /sdcard:
  even a *fat*-formatted device may be mounted there (e.g., a microSD card).

In the following, I discuss my decisions for the cross-build and the native
build, that are based on two different approaches and destination directories;
read the patches to better understand what the hell I have done :-)
Obviously, if you know what you are doing, you can "mix" such approaches
as you prefer.

Cross-build
-----------
In init_homedir() (src/misc1.c), instead of getting content of the
HOME env var,
- define a /sdcard/[username] path
- put this path in the HOME env var
- mkdir $HOME, $HOME/tmp, $HOME/.vim: very likely, they do not exist
  at the first run
In src/os_unix.h, I adapted many paths to the Android filesystem.
To fulfill other VIM requirements, when the package is installed,
the /sdcard/tmp dir has to be created if it does not exist.
In src/ex_cmds.c, I disabled the viminfo file ownership test for __BIONIC__

Native build
------------
I used the /data/local directory tree instead of the /system one.
This way, you do not need to remount /system as rw each time you have to
either install or edit some configurations.
Furthermore, /data/local should remain unchanged if you flash the device
with another Android version.
However, accordingly, you have to edit the shell rc file(s) to set
PATH=/data/local/bin:$PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/local/lib
(after all, such settings are already needed to run the native GCC).
I decided to also set HOME through the shell rc file(s).
For hints about the shell(s) rc file(s) and about the choice of HOME,
please refer to the mksh and bash stuff on this repository.
This decision about the HOME environment variable is alternative to changes
to the code in vim74/src/misc1.c, that is not modified by the native patch.
All the other changes/patches are the same as for the cross-build,
even though with different directory paths, related to /data/local
instead of /system.

