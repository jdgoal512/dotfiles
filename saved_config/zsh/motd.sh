clear
printf "          [0;34m.         "
printf "[1;37m __ _ _ _ __|‾|_ [0;34m|‾(‾)_ _ _  ___ __"
printf "\n         [0;34m/#\\        "
printf "[1;37m/ _\` | \'_/ _| \' \\[0;34m| | | \' \\ || \\ \\ /"
printf "\n        [0;34m/###\       "
printf "[1;37m\\__,_|_| \\__|_||_[0;34m|_|_|_||_\\_,_/_\_\\"
printf "\n       [0;34m/#####\      "
printf "\n      [0;34m/[2;36m##'''##[0;34m\          "
printf "[1;34mWelcome %s" "$USER"
printf "\n     [2;36m/##;   ;##\      "
printf "[0;34mUptime:[0;37m "
uptime -p | sed -e 's/^...//' | xargs echo -n
printf "\n    [2;36m/###.   .###\     "
printf "[0;34mDisk usage:[0;37m "
df -h -t ext4 | grep / | awk '{print $3+0 " Gb/" $4+0 " Gb"}' | xargs echo -n
printf "\n   [2;36m/#'         '#\    "
printf "[0;34mRam:[0;37m "
free -h | grep Mem | awk '{print $3+0 " Gb/" $2+0 " Gb"}' | xargs echo -n
printf "\n"