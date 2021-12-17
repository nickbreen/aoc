#!/usr/bin/gawk --file

BEGIN {
    FPAT = "[0-9]"
    INFINITY = -log(0)
    REPEAT = r ? r : 0
}

BEGINFILE {
    Y = 0
    X = 0
    delete COST
    delete DIST
    delete UNVISITED
    delete FRONTIER
    MV = INFINITY
    MY = 1
    MX = 1
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
    for (r = 1; r <=REPEAT; r++) {
        for (y = 1; y <= Y; y++) {
            for (x = 1; x <= X; x++) {
                new_cost = (COST[y][x] + r - 1) % 9 + 1
                COST[y][r * X + x] = new_cost
                DIST[y][r * X + x] = INFINITY
                UNVISITED[y][r * X + x] = 1
            }
        }
    }
    X *= REPEAT ? REPEAT : 1

    for (r = 1; r <=REPEAT; r++) {
        for (y = 1; y <= Y; y++) {
            for (x = 1; x <= X; x++) {
                new_cost = (COST[y][x] + r - 1) % 9 + 1
                COST[r * Y + y][x] = new_cost
                DIST[r * Y + y][x] = INFINITY
                UNVISITED[r * Y + y][x] = 1
            }
        }
    }
    Y *= REPEAT ? REPEAT : 1

    DIST[MY][MX] = 0
    FRONTIER[MY][MX] = 0

    #print sprint_grid()

    while (length(FRONTIER)) {
        find_smallest_frontier()
    }

    print DIST[Y][X]
}

function consider_neighbours(y, x,     d) {
    #print "considering ", y "/" Y, x "/" X, COST[y][x], DIST[y][x]

    # south
    if (y < Y && UNVISITED[y+1][x]) {
        d = DIST[y][x] + COST[y+1][x]
        DIST[y+1][x] = DIST[y+1][x] < d ? DIST[y+1][x] : d
        FRONTIER[y+1][x+0] = DIST[y+1][x]
    }
    # north
    if (1 < y && UNVISITED[y-1][x]) {
        d = DIST[y][x] + COST[y-1][x]
        DIST[y-1][x] = DIST[y-1][x] < d ? DIST[y-1][x] : d
        FRONTIER[y-1][x+0] = DIST[y-1][x]
    }
    # west
    if (1 < x && UNVISITED[y][x-1]) {
        d = DIST[y][x] + COST[y][x-1]
        DIST[y][x-1] = DIST[y][x-1] < d ? DIST[y][x-1] : d
        FRONTIER[y+0][x-1] = DIST[y][x-1]
    }
    # east
    if (x < X && UNVISITED[y][x+1]) {
        d = DIST[y][x] + COST[y][x+1]
        DIST[y][x+1] = DIST[y][x+1] < d ? DIST[y][x+1] : d
        FRONTIER[y+0][x+1] = DIST[y][x+1]
    }

    UNVISITED[y][x] = 0
    delete FRONTIER[y][x]
    if (length(FRONTIER[y]) == 0) delete FRONTIER[y]

    #if (y % 5 == 0 || x % 5 == 0) print sprint_grid(), y "/" Y "," x "/" X
}

function find_smallest_frontier(   y, x, v, my, mx, s) {
    v = INFINITY
    #s = "frontier"
    for (y in FRONTIER) {
        y = int(y)
        for (x in FRONTIER[y]) {
            x = int(x)
    #        #s = s " " y "," x
            if (UNVISITED[y][x] && DIST[y][x] <= v) {
                v = DIST[y][x]
                my = y
                mx = x
            }
        }
    }
    #print s
    #for (y in FRONTIER) for (x in FRONTIER[y]) return consider_neighbours(int(y), int(x))
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