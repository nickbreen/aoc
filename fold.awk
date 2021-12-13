#!/usr/bin/awk --file


BEGIN {
    FS = "="
}

BEGINFILE {
    delete DOTS
    Y = 0
    X = 0
    VISIBLE_DOTS = 0
}

/[0-9]+,[0-9]+/ {
    split($0, xy, ",")
    x = xy[1]
    y = xy[2]

    Y = Y < y ? y : Y
    X = X < x ? x : X

    DOTS[y][x]++
}

/^$/ {
    print sprint_dots()
}

$1 ~ /^fold along x/ {
    foldx($2)
    print sprint_dots()
}

$1 ~ /^fold along y/ {
    foldy($2)
    print sprint_dots()
}

# part 1, stop at first fold
#$1 ~ /^fold along / {
#    nextfile
#}

ENDFILE {
    for (y = 0; y <= Y; y++)
        for (x = 0; x <= X; x++)
            if (DOTS[y][x]) VISIBLE_DOTS++
    print FILENAME, VISIBLE_DOTS
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