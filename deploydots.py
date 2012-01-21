#!/usr/bin/env python

"""
Quick and dumb script that takes all the files in the current directory
that isn't the script itself or a dot file, and makes a symlink for it
in the users home directory.

Usage: deploydots.py [OPTION]

Options:
    -u, --update-submodules
        update submodules used in this repository
"""

from __future__ import print_function

import getopt
import os
import shutil
import sys
from subprocess import call

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
            cprint("Previously deployed file:\t\t%s" % (linkpath),
                    bcolors.OKBLUE)
         # Otherwise, back up the existing file
        else:
            backupdir = cwd + os.sep + "backup"
            if not os.path.exists(backupdir):
                os.mkdir(backupdir)

            # Backup the file.
            cprint("Backing up file:\t\t\t%s" % (linkpath), bcolors.WARNING)
            if os.path.exists(backupdir + os.sep + dot):
                os.remove(backupdir + os.sep + dot)
            shutil.move(linkpath, backupdir + os.sep + dot)

            # Go ahead and deploy the file.
            cprint("Deploying %s:\t\t\t%s" % (dot, linkpath), bcolors.OKGREEN)
            os.symlink(dotpath, linkpath)

    else:
        cprint("Deploying %s:\t\t\t%s" % (dot, linkpath), bcolors.OKGREEN)
        os.symlink(dotpath, linkpath)


def update_submodules():
    cprint("Updating git submodules:\t\t", bcolors.OKGREEN, '')

    # TODO: Should switch this to actually handle error output
    if call(["git", "submodule", "update", "--init"]) == 0:
        cprint("Success", bcolors.OKGREEN)
    else:
        cprint("Failed", bcolors.FAIL)


def main(argv=None):
    do_update = False

    if argv is None:
        argv = sys.argv

    try:
        opts, args = getopt.getopt(sys.argv[1:],
                "hu", ["help", "update-submodules"])

    except getopt.error as msg:
        cprint(msg, bcolors.FAIL)
        cprint("For help use --help", bcolors.WARNING)
        sys.exit(1)

    for o, a in opts:
        if o in ("-h", "--help"):
            print(__doc__)
            sys.exit(0)
        elif o in ("-u", "--update-submodules"):
            do_update = True

    if do_update:
        update_submodules()
    dots = os.listdir('.')

    # Make symlinks for all the dots we find
    list(map(linkdot, [dot for dot in dots if sievedot(dot)]))


if __name__ == "__main__":
    exit(main())
