#!/usr/bin/gawk --file

@include "vent_lib.awk"

{
    add_vent(grid, $1, $2, $3, $4)
    min_max($1, $2, $3, $4)
}
