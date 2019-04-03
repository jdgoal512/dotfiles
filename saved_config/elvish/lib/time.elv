fn for [time function]{
    end_time = (+ (date +%s) $time)
    while (< (date +%s) $end_time) {
        $function
    }
}
