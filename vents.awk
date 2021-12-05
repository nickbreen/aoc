#!/usr/bin/gawk --file

BEGIN {
    FPAT = "[0-9]+"
}

# vertical positive
$1 == $3 && $2 < $4 {
    for (y = $2; y <= $4; y++) {
        grid[y][$1]++
    }
    min_x = min_x < $1 ? min_x : $1
    max_x = max_x < $1 ? $1 : max_x
    min_y = min_y < $2 ? min_y : $2
    max_y = max_y < $4 ? $4 : max_y
}
# vertical negative
$1 == $3 && $4 < $2 {
    for (y = $4; y <= $2; y++) {
        grid[y][$1]++
    }
    min_x = min_x < $1 ? min_x : $1
    max_x = max_x < $1 ? $1 : max_x
    min_y = min_y < $4 ? min_y : $4
    max_y = max_y < $2 ? $2 : max_y
}

# horizontal positive
$2 == $4 && $1 < $3 {
    for (x = $1; x <= $3; x++) {
        grid[$2][x]++
    }
    min_x = min_x < $1 ? min_x : $1
    max_x = max_x < $3 ? $3 : max_x
    min_y = min_y < $2 ? min_y : $2
    max_y = max_y < $2 ? $2 : max_y
}
# norizontal negative
$2 == $4 && $3 < $1 {
    for (x = $3; x <= $1; x++) {
        grid[$2][x]++
    }
    min_x = min_x < $3 ? min_x : $3
    max_x = max_x < $1 ? $1 : max_x
    min_y = min_y < $2 ? min_y : $2
    max_y = max_y < $2 ? $2 : max_y
}

END {
    print "END"

#    print_grid(grid, min_y, max_y, min_x, max_x)

    for (y in grid) for (x in grid[y]) if (grid[y][x] > 1) danger++

    print danger
}

#function print_grid(grid, min_y, max_y, min_x, max_x,      y, x) {
#    for (y = min_y; y <= max_y; y++) {
#        for (x = min_x; x <= max_x; x++) {
#            printf "%s", (y in grid && x in grid[y] ? grid[y][x] : ".")
#        }
#        printf "\n"
#    }
#}
