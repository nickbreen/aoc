#!/usr/bin/gawk --file


BEGIN {
    FS = "="
}

BEGINFILE {
    delete DOTS
    Y = 0
    X = 0
}

/[0-9]+,[0-9]+/ {
    split($0, xy, ",")
    x = xy[1]
    y = xy[2]

    Y = Y < y ? y : Y
    X = X < x ? x : X

    DOTS[y][x]++
}

$1 ~ /^fold along x/ {
    foldx($2)
}

$1 ~ /^fold along y/ {
    foldy($2)
}

$1 ~ /^fold along / {
    # part 1, stop at first fold
    if (part == 1) nextfile
}

ENDFILE {
    if (part == 1) {
        VISIBLE = 0
        for (y = 0; y <= Y; y++) for (x = 0; x <= X; x++) if (DOTS[y][x]) VISIBLE++
    }
    print FILENAME, VISIBLE
    if (part != 1) print sprint_dots()
}

function foldx(f,    y, x) {
    for (y = 0; y <= Y; y++) {
        for (x = f + 1; x <= X; x++)
            DOTS[y][f-(x-f)] += DOTS[y][x]
    }
    X = f-1
}

function foldy(f,    y, x) {
    for (y = f+1; y <= Y; y++) {
        for (x = 0; x <= X; x++)
            DOTS[f-(y-f)][x] += DOTS[y][x]
    }
    Y = f-1
}

function sprint_dots(      y, x, s) {
    for (y = 0; y <= Y; y++) {
        for (x = 0; x <= X; x++) s = s (DOTS[y][x] ? "#" : ".")
        s = s "\n"
    }
    return s
}