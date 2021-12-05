BEGIN {
    FPAT = "[0-9]+"
}

END {
    print_grid(grid, X1, Y1, X2, Y2)

    for (y in grid) for (x in grid[y]) if (grid[y][x] > 1) danger++

    print danger
}

function min_max(x1, y1, x2, y2) {
    X1 = X1 < x1 ? X1 : x1
    X1 = X1 < x2 ? X1 : x2
    X2 = X2 < x1 ? x1 : X2
    X2 = X2 < x2 ? x2 : X2
    Y1 = Y1 < y1 ? Y1 : y1
    Y1 = Y1 < y2 ? Y1 : y2
    Y2 = Y2 < y1 ? y1 : Y2
    Y2 = Y2 < y2 ? y2 : Y2
}

function print_grid(grid, x1, y1, x2, y2,      y, x) {
    for (y = y1; y <= y2; y++) {
        for (x = x1; x <= x2; x++) {
            printf "%s", (y in grid && x in grid[y] ? grid[y][x] : ".")
        }
        printf "\n"
    }
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

