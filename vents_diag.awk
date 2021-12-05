#!/usr/bin/gawk --file

BEGIN {
    FPAT = "[0-9]+"
}

function add_vent(grid, x1, y1, x2, y2,   x, y, dx, dy) {
    dy = y1 < y2 ? 1 : (y1 > y2 ? -1 : 0)
    dx = x1 < x2 ? 1 : (x1 > x2 ? -1 : 0)
    y = y1
    x = x1
    for (;y != y2 || x != x2;) {
        grid[y][x]++
        y += dy
        x += dx
    }
    grid[y][x]++
}

function min_max(x1, y1, x2, y2) {
    min_x = min_x < x1 ? min_x : x1
    min_x = min_x < x2 ? min_x : x2
    max_x = max_x < x1 ? x1 : max_x
    max_x = max_x < x2 ? x2 : max_x
    min_y = min_y < y1 ? min_y : y1
    min_y = min_y < y2 ? min_y : y2
    max_y = max_y < y1 ? y1 : max_y
    max_y = max_y < y2 ? y2 : max_y
}

{
    add_vent(grid, $1, $2, $3, $4)
    min_max($1, $2, $3, $4)
}

END {
    print_grid(grid, min_y, max_y, min_x, max_x)

    for (y in grid) for (x in grid[y]) if (grid[y][x] > 1) danger++

    print danger
}

function print_grid(grid, min_y, max_y, min_x, max_x,      y, x) {
    for (y = min_y; y <= max_y; y++) {
        for (x = min_x; x <= max_x; x++) {
            printf "%s", (y in grid && x in grid[y] ? grid[y][x] : ".")
        }
        printf "\n"
    }
}
