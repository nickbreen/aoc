#!/usr/bin/awk -f

BEGIN {
    if (!window_size) window_size = 3
}

{
    i = NR % window_size
    sum -= window[i]
    window[i] = $1
    sum += window[i]
}

window_size <= NR {
    print sum
}