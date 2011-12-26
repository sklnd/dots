#!/usr/bin/env python

"""
Quick and dumb script that takes all the files in the current directory
that isn't the script itself or a dot file, and makes a symlink for it
in the users home directory.
"""

import os
import shutil

# Blacklisted files
blacklist = [os.path.basename(__file__), 'backup']

# Stolen from a stackoverflow post on how to print term colors, came originally
# from blender build scripts.
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

def cprint(string, color):
    print color + string + bcolors.ENDC

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
    # If the file is a symlink pointing to the dots directory, it is previously
    # deployed from this repo. Print a log line and ignore it.
    if os.path.realpath(linkpath) == dotpath:
      cprint("Previously deployed file:\t\t%s" % (linkpath), bcolors.OKBLUE)
    # Otherwise, back up the existing file
    else:
      backupdir = cwd + os.sep + "backup"
      if not os.path.exists(backupdir):
        os.mkdir(backupdir)

      cprint("Backing up file:\t\t\t%s" % (linkpath), bcolors.WARNING)
      if os.path.exists(backupdir + os.sep + dot):
        os.remove(backupdir + os.sep + dot)
      shutil.move(linkpath, backupdir + os.sep + dot)

      cprint("Deploying %s:\t\t\t%s" % (dot, linkpath), bcolors.OKGREEN)
      os.symlink(dotpath, linkpath)
  else:
    cprint("Deploying %s:\t\t\t%s" % (dot, linkpath), bcolors.OKGREEN)
    os.symlink(dotpath, linkpath)


dots = os.listdir('.')

# Make symlinks for all the dots we find
map(linkdot, [dot for dot in dots if sievedot(dot)])
