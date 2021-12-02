#!/usr/bin/awk -f

{
    if (previous && previous < $1) {
        increases++
    }
    previous=$1
}

END {
    print increases
}
