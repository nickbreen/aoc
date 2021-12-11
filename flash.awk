#!/usr/bin/awk --file

BEGIN {
    FPAT = "[0-9]"
    STEPS = steps ? steps : 100
}

{
    for (i = 1; i <= NF; i++) store_octopus(NR, i, $i)
    X = NF
    Y = NR
}

function store_octopus(y, x, z) {
    OCTO[y][x] = z
}

function print_octopus(     y, x, s) {
    for (y = 1; y <= Y; y++) {
        for (x = 1; x <= X; x++)
            s = s (FLASHED[y][x] ? "\033[33m" (9 < OCTO[y][x] ? "*" : OCTO[y][x]) "\033[0m" : (9 < OCTO[y][x] ? "*" : OCTO[y][x]))
        s = s "\n"
    }
    return s "\n"
}

END {
    for (i = 1; i <= STEPS; i++) {
        step_octopus()
        step_flashes = 0
        for (flashes = flash_octopus(); flashes; flashes = flash_octopus()) {
            FLASHES += flashes
            step_flashes += flashes
            print print_octopus()
        }
        if (step_flashes == Y * X) {
            print "WOW!!!", i
            exit 0
        }
        zero_octopus()
        print print_octopus()
        delete FLASHED
    }
    print FLASHES
}

function step_octopus(    y, x) {
    for (y = 1; y <= Y; y++) for (x = 1; x <= X; x++) OCTO[y][x]++
}

function zero_octopus(    y, x) {
    for (y = 1; y <= Y; y++) for (x = 1; x <= X; x++) if (FLASHED[y][x]) OCTO[y][x] = 0
}

function flash_octopus(      flashes, y, x) {
    for (y = 1; y <= Y; y++)
        for (x = 1; x <= X; x++)
            if (9 < OCTO[y][x] && !FLASHED[y][x]) {
                FLASHED[y][x]++
                flashes++
                print y "/" Y, x "/" X, "N", 1 < y, "NW", 1 < y && 1 < x, "W", 1 < x, "SW", y < Y && 1 < x, "S", y < Y, "SE", y < Y && x < X, "E", x < X, "NE", 1 < y && x < X
                if (1 < y)          OCTO[y-1][x]++   # N
                if (1 < y && 1 < x) OCTO[y-1][x-1]++ # NW
                if (1 < x)          OCTO[y][x-1]++   # W
                if (y < Y && 1 < x) OCTO[y+1][x-1]++ # SW
                if (y < Y)          OCTO[y+1][x]++   # S
                if (y < Y && x < X) OCTO[y+1][x+1]++ # SE
                if (x < X)          OCTO[y][x+1]++   # E
                if (1 < y && x < X) OCTO[y-1][x+1]++ # NE
            }
    return flashes
}