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
df -h -t ext4 -t ext3 | grep / | awk '{print "[\033[92m"$6"\033[37m "($5+0<50 ? "\033[92m" : ($5+0<75 ? "\033[33m" : "\033[31m"))$5"\033[37m "$3 "b/" $4 "b ]"}' | tr '\n' ' ' 
printf "\n   [2;36m/#'         '#\    "
free | grep Mem | awk '{p=$3/$2*100;print "\033[0;34mRam: "(p<50?"\033[92m":(p<75?"\033[33m":"\033[21m"))p+0"%\033[37m "}' | tr -d '\n'
free -h | grep Mem | awk '{print $3 "b/" $2 "b"}' | sed -r 's/([0-9])([a-zA-Z])/\1 \2/g; s/([a-zA-Z])([0-9])/\1 \2/g' | xargs echo -n
printf "[0;37m\n"
