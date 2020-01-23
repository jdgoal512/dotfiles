fn zip [@rest]{
    if (eq $rest []) {
        return
    }
    n = (count $rest[0])
    for list $rest[1:] {
        if (> $n (count $list)) {
            n = (count $list)
        }
    }
    for i [(range $n)] {
        put [$@rest[$i]]
    }
}

fn enumerate [list]{
    i = 0
    for item $list {
        put [$i $item]
        i = (+ $i 1)
    }
}

# Don't actually use this just use it for reference
fn append [list @rest]{
    put [$@list $@rest]
}
