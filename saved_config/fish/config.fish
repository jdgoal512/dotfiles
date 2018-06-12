function fish_greeting
    set RED "\033[0;31m"
    set WHITE "\033[0;37m"
    set LIGHTBLUE "\033[1;34m"
    set DARKBLUE "\033[0;34m"

    printf "$RED   .----\n  .    #   "
    printf $LIGHTBLUE"Welcome $USER@"(hostname)"\n"
    printf "$RED  |   #    "$DARKBLUE"Uptime: $WHITE"
    uptime -p \
        | sed -e 's/^...//' \
        | xargs echo -n
    printf "\n$RED  |  ###   "$DARKBLUE"Disk usage: "
    df -h -t ext4 -t ext3 2>&1 \
        | grep / \
        | awk '{print "\033[37m[\033[36m"$6"\033[37m "($5+0<50 ? "\033[92m" : ($5+0<75 ? "\033[33m" : "\033[31m"))$5"\033[37m "$3 "b/" $4 "b]"}' \
        | tr '\n' ' ' 
    printf "\n$RED  .    #   "
    free \
        | grep Mem \
        | awk '{p=$3/$2*100;printf "\033[0;34mRam: "(p<50?"\033[92m":(p<75?"\033[33m":"\033[21m")); printf "%.2f%\033[37m ", p}' \
        | tr -d '\n'
    free -h \
        | grep Mem \
        | awk '{print $3 "b/" $2 "b"}' \
        | sed -r 's/([0-9])([a-zA-Z])/\1 \2/g; s/([a-zA-Z])([0-9])/\1 \2/g' \
        | xargs echo -n
    printf "\n$RED   .----\n"
end

function cdls
    if count $argv > /dev/null
        set new_dir "$argv"
    else
        set new_dir "$HOME"
    end
    builtin cd "$new_dir"; and ls
end

alias cd="cdls"
function git_branch
    set -g git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
    if [ $status -ne 0 ]
        set -ge git_branch
        set -g git_dirty_count 0
    else
        set -g git_dirty_count (git status --porcelain  | wc -l | sed "s/ //g")
    end
end

function git_prompt
   if test -e .git; or git rev-parse --git-dir >/dev/null 2>&1
       if not test -z (git status --porcelain 2>/dev/null | tail -n1)
           printf "\033[0;31m*"
       end
       git branch | grep "\*" | awk '{print "\033[32m["$2"]"}' | tr -d "\n"
   end
end

function _common_section
    printf $c1
    printf $argv[1]
    printf $c0
    printf ":"
    printf $c2
    printf $argv[2]
    printf $argv[3]
    printf $c0
    printf ", "
end

function section
    _common_section $argv[1] $c3 $argv[2] $ce
end

function error
    _common_section $argv[1] $ce $argv[2] $ce
end

function fish_prompt
    #printf "$USER@"(hostname)" "
    # $status gets nuked as soon as something else is run, e.g. set_color
    # so it has to be saved asap.
    set -l last_status $status

    # c0 to c4 progress from dark to bright
    # ce is the error colour
    set -g c0 (set_color 005284)
    set -g c1 (set_color 0075cd)
    set -g c2 (set_color 009eff)
    set -g c3 (set_color 6dc7ff)
    set -g c4 (set_color ffffff)
    set -g ce (set_color $fish_color_error)

    # Clear the line because fish seems to emit the prompt twice. The initial
    # display, then when you press enter.
    printf "\033[K"

    # Current time
    if [ $last_status -ne 0 ]
        error last $last_status
        set -ge status
    end

    # Track the last non-empty command. It's a bit of a hack to make sure
    # execution time and last command is tracked correctly.
    set -l cmd_line (commandline)
    if test -n "$cmd_line"
        set -g last_cmd_line $cmd_line
        set -ge new_prompt
    else
        set -g new_prompt true
    end

    # Show loadavg when too high
    set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
    set -l load1m_test (math $load1m \* 100 / 1)
    if test $load1m_test -gt 100
        error load $load1m
    end

    # Show disk usage when low
    set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
    if test $du -gt 80
        error du $du%%
    end

    # Virtual Env
    if set -q VIRTUAL_ENV
        section env (basename "$VIRTUAL_ENV")
    end

    git_prompt
#    # Git branch and dirty files
#    git_branch
#    if set -q git_branch
#        set out $git_branch
#        if test $git_dirty_count -gt 0
#            set out "$out$c0:$ce$git_dirty_count"
#        end
#        section git $out
#    end

    # Current Directory
    # 1st sed for colourising forward slashes
    # 2nd sed for colourising the deepest path (the 'm' is the last char in the
    # ANSI colour code that needs to be stripped)
    printf $c1
    printf $c0"[$c1"(pwd | sed "s,$HOME,~," | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c3,")"$c0]"

    # Prompt on a new line
    printf $c4
    printf "> "
end
