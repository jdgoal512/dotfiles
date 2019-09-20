fn isnumber [@args]{
    for x $args {
        try {
            nop (+ $x 0)
            put $true
        } except {
            put $false
        }
    }
}

fn testnumber [@args]{
    for x $args {
        if (not (isnumber $x)) {
            fail $x" is not a valid number"
        }
    }
}

fn floor [@args]{
    testnumber $@args
    for x $args {
        put [(splits "." $x)][0]
    }
}

fn ceil [@args]{
    testnumber $@args
    for x $args {
        round_down = (floor $x)
        if (== $round_down $x) {
            put $round_down
        } else {
            put (+ $round_down 1)
        }
    }
}

fn round [@args]{
    testnumber $@args
    for x $args {
        if (== (* (floor $x) 2) (floor (* $x 2))) {
            put (floor $x)
        } else {
            put (ceil $x)
        }
    }
}

fn pi {
    put 3.14159265359
}

fn average [@args]{
    put (/ (+ $@args) (count $args))
}

fn sqrt [@args]{
    for arg $args {
        put (^ $arg .5)
    }
}
