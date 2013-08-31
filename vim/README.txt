
vim-NOTES-7.4.txt provides instructions to build and install VIM for Android.
vim-7.4-android.patch is a patch to build VIM for Android.
vim-7.3-android.patch: you should not need this (read vim-NOTES-7.4.txt).
vimrc-android: my favourite vimrc for Android.
screenshots/ : in this directory, you can find some screenshots :-)

Some explanations are needed to understand the rationale behind all parts
of the patch and to describe the directory structure I have chosen.

Cross-compiling VIM for Android is not so difficult.
I only found a problem building it with multibyte support, as Bionic
does not provide mblen(); in src/mbyte.c I added __BIONIC__ to the list
of platforms where mblen() is not available; maybe this is not the best
solution, suggestions are welcome.
Anyway, I did not work so much on this issue, as I suspect that remaining
problems in multibyte support are due to the Android Terminal: as an example,
try to type and delete some italian accented letters on the shell prompt,
to understand what I mean.

Apart from the only build stopper, i.e. the lack of mblen(),
I faced some problems related to paths and environment variables.

The simpler problem: system executables (e.g. "sh") are not
in /bin and /usr/bin, but in /system/bin and /system/xbin; just find
affected files and edit paths.

Worse problems are related to $HOME, /tmp, /var/tmp.
On whatever Unix system I put my hands, both the root and an unprivileged
user can enter the $HOME dir and create/delete/edit files in it; hence,
IMHO, in the VIM code, the assumption that the program can create/delete/edit
files in $HOME it is absolutely reasonable.
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
but an unprivileged user can't.
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
- the only dir I can rely on is /sdcard
- alas, file/dir owners/groups/permissions are not reliable on /sdcard:
  even a *fat*-formatted device may be mounted there (e.g., a microSD card).

My decisions are in the following; read the patch to better understand
what the hell I have done :-)
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

