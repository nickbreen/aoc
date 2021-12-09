#!/usr/bin/gawk --file

BEGIN {
    FPAT = "[0-9]"
}

{
    for (x = 1; x <= NF; x++) grid[NR][x] = $x
    X = NF
    Y = NR
}

END {
    #print_grid(grid)
    find_low_points(grid, low_points)
    for (y in low_points) for (x in low_points[y]) basins[y "," x] = find_basin(grid, y, x)
    #print_grid(grid)
    PROCINFO["sorted_in"]="@val_num_desc"
    #for (b in basins) print "basin", b, "size", basins[b]
    basin_multiple = 1
    basin_multiple_count = 0
    for (b in basins) {
        basin_multiple *= basins[b]
        if (3 <= ++basin_multiple_count) break
    }
    print basin_multiple
}

function print_grid(grid,     x, y, s) {
    for (y in grid) {
        for (x in grid[y]) s = s sprintf("%d", grid[y][x])
        s = s "\n"
    }
    print s
}

function find_low_points(grid, points,   y, x, n, s, w, e) {
    for (y in grid) {
        for (x in grid[y]) {
            n = y == 1 ? 10 : grid[y-1][x]
            s = y == Y ? 10 : grid[y+1][x]
            w = x == 1 ? 10 : grid[y][x-1]
            e = x == X ? 10 : grid[y][x+1]

            if (grid[y][x] < n && grid[y][x] < s && grid[y][x] < e && grid[y][x] < w) {
                #print "found low point", y, x, grid[y][x]
                points[y][x] = grid[y][x]
            }
        }
    }
}

function find_basin(grid, y, x, i,    z, n, s, w, e, basin) {
    if (grid[y][x] == 9) return 0

    z = grid[y][x]
    grid[y][x] = 0

    basin = 1
    n = y == 1 ? 0 : grid[y-1][x]
    if (n) basin += find_basin(grid, y-1, x, i "   ")
    s = y == Y ? 0 : grid[y+1][x]
    if (s) basin += find_basin(grid, y+1, x, i "   ")
    w = x == 1 ? 0 : grid[y][x-1]
    if (w) basin += find_basin(grid, y, x-1, i "   ")
    e = x == X ? 0 : grid[y][x+1]
    if (e) basin += find_basin(grid, y, x+1, i "   ")

    #print i y "," x, z, n s w e, basin

    return basin
}