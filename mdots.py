#!/usr/bin/env python3

"""
A script for maintaining a dots repository.

Features:
    * Maintains a symlink farm for all files in the repository to the user's
      home directory as dotfiles. Existing dotfiles that conflict with dotfiles
      that conflict with files being deployed are backed up to a backup
      directory in the repository.

Usage: mdots.py

Options:
"""

from os import path
import getopt
import os
import shutil
import sys

# Blacklisted files
blacklist = [os.path.basename(__file__),
             'backup',
             'readme.markdown']


# Stolen from a stackoverflow post on how to print term colors, came originally
# from blender build scripts.
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'


def cprint(string, color, end=os.linesep):
    if not type(string) == str:
        string = string.__str__()

    print((color + string + bcolors.ENDC), end=end)


def sievedot(dot):
    if dot[0] == '.' or dot in blacklist:
        return False
    else:
        return True


def linkdot(dot):
    cwd = os.getcwd()
    homepath = os.getenv("HOME")
    linkpath = homepath + os.sep + '.' + dot
    dotpath = cwd + os.sep + dot

    if os.path.exists(linkpath):
        # If the file is a symlink pointing to the dots directory, it is
        # previously deployed from this repo. Print a log line and ignore it.
        if os.path.realpath(linkpath) == dotpath:
            cprint('{:60} {}'.format('Previously deployed file:', linkpath),
                   bcolors.OKBLUE)
        # Otherwise, back up the existing file
        else:
            backupdir = cwd + os.sep + "backup"
            if not os.path.exists(backupdir):
                os.mkdir(backupdir)

            # Backup the file.
            cprint('{:60} {}'.format('Backing up file:', linkpath),
                   bcolors.WARNING)
            if os.path.exists(os.path.join(backupdir, dot)):
                os.remove(path.join(backupdir, dot))
            shutil.move(linkpath, path.join(backupdir, dot))

            # Go ahead and deploy the file.
            cprint('{:60} {}'.format('Deploying ' + dot + ':', linkpath),
                   bcolors.OKGREEN)
            os.symlink(dotpath, linkpath)

    else:
        cprint('{:60} {}'.format('Deploying ' + dot + ':', linkpath),
               bcolors.OKGREEN)
        os.symlink(dotpath, linkpath)


def main(argv=None):
    if argv is None:
        argv = sys.argv

    try:
        opts, args = getopt.getopt(sys.argv[1:], "ahu",
                                   ["help",
                                    "update-submodules",
                                    "add-vim-plugin"])

    except getopt.error as msg:
        cprint(msg, bcolors.FAIL)
        cprint("For help use --help", bcolors.WARNING)
        sys.exit(1)

    for o, a in opts:
        if o in ("-h", "--help"):
            print(__doc__)
            sys.exit(0)

    dots = os.listdir('.')

    # Make symlinks for all the dots we find
    list(map(linkdot, [dot for dot in dots if sievedot(dot)]))


if __name__ == "__main__":
    exit(main())
