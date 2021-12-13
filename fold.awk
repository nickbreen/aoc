#!/usr/bin/awk --file


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

ENDFILE {
    print sprint_dots()
}

function foldx(x) {

}

function foldy(y) {

}

function sprint_dots(      y, x, s) {
    for (y = 0; y <= Y; y++) {
        for (x = 0; x <= X; x++) s = s (DOTS[y][x] ? "#" : ".")
        s = s "\n"
    }
    return s
}