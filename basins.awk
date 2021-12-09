#!/usr/bin/awk --file

BEGIN {
    FPAT = "[0-9]"
}

{
    for (x = 1; x <= NF; x++) grid[NR][x] = $x
    X = NF
    Y = NR
}

END {
    print_grid(grid)
    find_low_points(grid, low_points)
    for (y in low_points) for (x in low_points[y]) print y, x, low_points[y][x], risk += low_points[y][x] + 1
    print risk
}

function print_grid(grid,     x, y, s) {
    for (y in grid) {
        for (x in grid[y]) s = s sprintf("%d", grid[y][x])
        s = s "\n"
    }
    print s
}

function find_low_points(grid, points,   y, x) {
    for (y in grid) {
        for (x in grid[y]) {
            N = y == 1 ? 10 : grid[y-1][x]
            S = y == Y ? 10 : grid[y+1][x]
            W = x == 1 ? 10 : grid[y][x-1]
            E = x == X ? 10 : grid[y][x+1]

            if (grid[y][x] < N && grid[y][x] < S && grid[y][x] < E && grid[y][x] < W) {
                print "found low point", y, x, grid[y][x]
                points[y][x] = grid[y][x]
            }
        }
    }
}