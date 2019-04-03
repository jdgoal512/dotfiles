fn tobinary [&prefix=$true @args]{
    if $prefix {
        for x [(base 2 $@args)] {
            put "0b"$x
        }
    } else {
        for x [(base 2 $@args)] {
            put $x
        }
    }
}

fn frombinary [@args]{
    for n $args {
        #Strip "0b" from the front if it is present
        if (and (< 2 (count $n)) (eq "0b" $n[0:2])) {
            n = $n[2:]
        }
        i = 0
        total = 0
        for i [(range (count $n))] {
            if (eq "1" $n[(- -1 $i)]) {
                total = (+ $total (^ 2 $i))
            }
        }
        put $total
    }
}

fn and [base_num @rest]{
    
}
