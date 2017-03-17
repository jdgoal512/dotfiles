# dotfiles
Config files for arch linux

I made this program to make it easier for me to apply any changes I make in my config files apply to new setups or different systems without manually copying all the files every time I make a change. Instead, it's all here. Just add the filenames to the list in FILE_LIST.txt for it to keep track of them. The format of the file is just the path of the file is actually on the system followed by a colon, followed the path that should be stored as in this project. You are allowed to use system variable names in the path. For example, /home/$USER/.bashrc:bashrc would make a copy of your .basrc as bashrc in the local directory. To copy your existing configuration, just run ./copy_config.sh. To apply the configuration in the local folder to your system, just run ./apply_config.sh. It's prety straightforward.
