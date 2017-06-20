clear
printf "          [0;34m.         "
printf "[1;37m __ _ _ _ __| |_ [0;34m| ( )_ _ _  ___ __"
printf "\n         [0;34m/#\\        "
printf "[1;37m/ _\` | \'_/ _| \' \\[0;34m| | | \' \\ || \\ \\ /"
printf "\n        [0;34m/###\       "
printf "[1;37m\\__,_|_| \\__|_||_[0;34m|_|_|_||_\\_,_/_\_\\"
printf "\n       [0;34m/#####\      "
printf "\n      [0;34m/[2;36m##'''##[0;34m\          "
printf "[1;34mWelcome %s@%s" "$USER" $(hostname)
printf "\n     [2;36m/##;   ;##\      "
printf "[0;34mUptime:[0;37m "
uptime -p | sed -e 's/^...//' | xargs echo -n
printf "\n    [2;36m/###.   .###\     "
printf "[0;34mDisk usage:[0;37m "
df -h -t ext4 -t ext3 | grep / | awk '{print "["$3 "b\033[34m/\033[37m" $4 "b \033[92m"$6"\033[37m]"}' | tr '\n' ' ' 
printf "\n   [2;36m/#'         '#\    "
printf "[0;34mRam:[0;37m "
free -h | grep Mem | awk '{print $3 "b/" $2 "b"}' | sed -r 's/([0-9])([a-zA-Z])/\1 \2/g; s/([a-zA-Z])([0-9])/\1 \2/g' | xargs echo -n
printf "\n"
