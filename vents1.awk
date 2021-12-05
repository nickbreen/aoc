#!/usr/bin/gawk --file

@include "vent_lib.awk"

$1 == $3 || $2 == $4 {
    add_vent(grid, $1, $2, $3, $4)
    min_max($1, $2, $3, $4)
}
