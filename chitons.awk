#!/usr/bin/gawk --file

BEGIN {
    FPAT = "[0-9]"
    INFINITY = -log(0)
}

BEGINFILE {
    Y = 0
    X = 0
    delete COST
    delete DIST
    delete UNVISITED
}

{
    for (i = 1; i <= NF; i++) {
        COST[NR][i] = $i
        DIST[NR][i] = INFINITY
        UNVISITED[NR][i] = 1
    }
    Y = NR
    X = NF
}

ENDFILE {
    DIST[1][1] = 0

    print sprint_grid()

    print consider_neighbours(1, 1)
}


function consider_neighbours(y, x,     d) {
    print "considering ", y "/" Y, x "/" X, COST[y][x], DIST[y][x]

    # north
    if (1 < y && UNVISITED[y-1][x]) {
        d = DIST[y][x] + COST[y-1][x]
        DIST[y-1][x] = DIST[y-1][x] < d ? DIST[y-1][x] : d
    }
    # south
    if (y < Y && UNVISITED[y+1][x]) {
        d = DIST[y][x] + COST[y+1][x]
        DIST[y+1][x] = DIST[y+1][x] < d ? DIST[y+1][x] : d
    }
    # west
    if (1 < x && UNVISITED[y][x-1]) {
        d = DIST[y][x] + COST[y][x-1]
        DIST[y][x-1] = DIST[y][x-1] < d ? DIST[y][x-1] : d
    }
    # east
    if (x < X && UNVISITED[y][x+1]) {
        d = DIST[y][x] + COST[y][x+1]
        DIST[y][x+1] = DIST[y][x+1] < d ? DIST[y][x+1] : d
    }

    UNVISITED[y][x] = 0

    print sprint_grid()

    if (UNVISITED[Y][X] == 0) return DIST[y][x]

    return find_smallest_unvisited()
}


function find_smallest_unvisited(   y, x, v, my, mx) {
    v = INFINITY
    for (y = 1; y <= Y; y++)
            for (x = 1; x <= X; x++)
                if (UNVISITED[y][x] && DIST[y][x] <= v) {
                    v = DIST[y][x]
                    my = y
                    mx = x
                }

    print "found smallest", my, mx, v

    return consider_neighbours(my, mx)
}

function sprint_grid(   s, y, x) {
    for (y = 1; y <= Y; y++) {
        for (x = 1; x <= X; x++)
            s = s (UNVISITED[y][x] ? COST[y][x] : yellow("*"))
        s = s "\n"
    }
    return s
}


function yellow(s) {
    return "\033[33m" s "\033[0m"
}