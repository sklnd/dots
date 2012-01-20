## Dots ##
This is a git repository containing my non-sensitive dot files along with a python script for dot file deployment. It creates a symlink in the users $HOME directory for each dot file.

When initially deploying the dot files, the script will backup existing files to a backup directory in the git repository. This backup process will blindly eat your previously backed up data if a file needs to be backed up during deployment, fair warning.

It has had minimal testing, and there are probably better implementations of this idea elsewhere. I have my reasons for writing my own personal implementation, aside from a healthy dose of NIH. I suggest looking for those other better-tested implementations, as you probably don't have the same reasons I do for reinventing things.
