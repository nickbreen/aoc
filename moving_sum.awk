#!/usr/bin/awk -f

{
    i = NR % 3
    sum -= window[i]
    window[i] = $1
    sum += window[i]
}

window_size <= NR {
    print sum
}