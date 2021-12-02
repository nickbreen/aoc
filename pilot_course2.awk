#!/usr/bin/awk --file

$1 == "forward" {
    position_h += $2
    position_v += $2 * aim
}

$1 == "down" {
    aim += $2
}

$1 == "up" {
    aim -= $2
}

END {
    print position_h * position_v
}