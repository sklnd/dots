#!/usr/bin/env python

"""
Quick and dumb script that takes all the files in the current directory
that isn't the script itself or a dot file, and makes a symlink for it
in the users home directory.
"""

import os

def sievedot(dot):
  if dot[0] == '.' or dot == os.path.basename(__file__):
    return False
  else:
    return True

def linkdot(dot):
  cwd = os.getcwd()
  homepath = os.getenv("HOME")
  linkpath = homepath + os.sep + '.' + dot
  dotpath = cwd + os.sep + dot

  if os.path.exists(linkpath):
    print "Dotfile %s already exists. Skipping." % (linkpath)
  else:
    os.symlink(dotpath, linkpath)


dots = os.listdir('.')

# Make symlinks for all the dots we find
map(linkdot, [dot for dot in dots if sievedot(dot)])
