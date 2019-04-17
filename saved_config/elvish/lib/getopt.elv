fn flag [flag @args]{
    if (eq $flag[0] '-') {
        flag = $flag[1:]
        if (eq $flag[0] '-') {
            flag = $flag[1:]
        }
    }
    for arg $args {
        if (eq $arg[0] '-') {
            arg = $arg[1:]
            try {
                if (eq $arg[0] '-') {
                    arg = $arg[1:]
                }
                if (eq $flag $arg) {
                    put $true
                    return
                }
            } except { }
        }
    }
    put $false
}

fn opt [opt @args]{
    for i [(range (- (count $args) 1))] {
        if (eq $opt $args[$i]) {
            put $args[(+ $i 1)]
            return
        }
    }
    fail "Option "$opt" not found"
}

fn getopts [&@flags=[] &@opts=[&] @args]{
    args_no_opts = $args
    #Remove opts from arguments
    for opt [(keys $opts)] {
        new_args = []
        i = 0
        while (< $i (count $args_no_opts)) {
            #Add last arg onto the list if the end is reached
            if (eq $i (- (count $args_no_opts) 1)) {
                new_args = [$@new_args $args_no_opts[-1]]
            } else {
                if (eq $opt $args_no_opts[$i]) {
                    opts[$opt] = $args_no_opts[(+ $i 1)]
                    rest = $args_no_opts[(+ $i 2):]
                    new_args = [$@new_args $@rest]
                    break
                } else {
                    new_args = [$@new_args $args_no_opts[$i]]
                }
            }
            i = (+ $i 1)
        }
        args_no_opts = $new_args
    }
    #Remove - and -- from front of flag arguments if present
    formatted_flags = []
    for flag $flags {
        if (eq $flag[0] '-') {
            flag = $flag[1:]
            if (eq $flag[0] '-') {
                flag = $flag[1:]
            }
        }
        formatted_flags = [$@formatted_flags $flag]
    }
    #Initialize flags to false
    found_flags = [&]
    for flag $formatted_flags {
        found_flags[$flag] = $false
    }
    #Find flags and remove them from the arguments
    new_args = []
    for i [(range (count $args_no_opts))] {
        arg = $args_no_opts[$i]
        add_arg = $true
        for flag $formatted_flags {
            if (eq $arg[0] '-') {
                flag_arg = $arg[1:]
                try {
                    if (eq $flag_arg[0] '-') {
                        flag_arg = $flag_arg[1:]
                    }
                    if (eq $flag $flag_arg) {
                        add_arg = $false
                        found_flags[$flag] = $true
                        break
                    }
                } except { }
            }
        }
        if $add_arg {
            new_args = [$@new_args $arg]
        }
    }
    output = [&opts=$opts &flags=$found_flags &args=$new_args]
    put $output
}
