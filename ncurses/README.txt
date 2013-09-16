
ncurses-NOTES-5.9.txt
---------------------
How to build and install ncurses for Android.

ncurses-5.9-android.patch
-------------------------
Android does not provide a complete locale support.

ncurses-5.9-android-sdcardhome.patch
------------------------------------
As I wrote in documentation of the VIM build, "there is no place like $HOME",
but, alas, this is not true for androids :-)
To summarize: on Android, it is not easy to foresee the value of the HOME
env var, that may even depend on the terminal/shell/etc. you are running;
furthermore, your $HOME could be on a read-only mounted file system and/or
it may be a dir for which you do not have write permission, and so on.
Ncurses assumes that the user's terminfo database, if present, is in the
$HOME/.terminfo directory, and the user may want to use this feature.
This may not be a problem if the ncurses library is linked by a program
that has been modified to overwrite HOME: as an example, I patched VIM
to set HOME=/sdcard/[username] through setenv(). Ncurses is invoked when
HOME has been already overwritten by VIM, hence, accordingly, in this case,
ncurses assumes that the user's terminfo database is in
/sdcard/[username]/.terminfo i.e. a directory that is manageable by the user.
But if ncurses is invoked either before HOME is overwritten, or by a program
that does not overwrite HOME, usage of the $HOME/.terminfo database may
be prevented.
To workaround this problem, I decided to patch the ncurses code to move the
user's terminfo from $HOME/.terminfo to /sdcard/[username]/.terminfo anyway.
At first, I patched ncurses to overwrite the HOME value accordingly, through
setenv(), as I did for VIM.
However, IMHO, this was not the best solution for the ncurses code:
- the generic program using ncurses could rely on the "original" value
  of the HOME env var, and it could not expect that a linked library
  overwrites it;
- the program invoking ncurses could overwrite HOME with a different
  directory, according to a different criterion.
To avoid confusion/conflicts, I finally decided to move from $HOME/.terminfo
to /sdcard/[username]/.terminfo without overwriting the HOME env var:
I commented out code lines needed to also overwrite HOME; you can easily
understand and restore them if you want.
How should you use this patch?
- If you are not interested in the user's terminfo database feature,
  you can ignore this patch.
- If you want to put the user's terminfo database in
  /sdcard/[username]/.terminfo without overwriting HOME, apply this patch.
- If you also want to overwrite HOME, use commented out lines
  (however, IMHO, this is not advisable).
- If you want to put the user's terminfo database elsewhere, you may take
  a cue from my patch and change the code according to your needs/preferences.

