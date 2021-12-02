#!/usr/bin/awk --file

$1 == "forward" {
    position_h += $2
}

$1 == "down" {
    position_v += $2
}

$1 == "up" {
    position_v -= $2
}

END {
    print position_h * position_v
}