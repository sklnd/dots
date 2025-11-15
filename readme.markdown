## Dots ##
This was a git repository containing my non-sensitive dot files along with a python script for dot file deployment. It creates a symlink in the users $HOME directory for each dot file.

When initially deploying the dot files, the script will backup existing files to a backup directory in the git repository. This backup process will blindly eat your previously backed up data if a file needs to be backed up during deployment, fair warning.

I have since moved to using nix to manage my machines and homemanager to manage my home environment. Thus, this repo has served its purpose, and is archived.
