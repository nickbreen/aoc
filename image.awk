#!/usr/bin/awk --file

BEGIN {
    ROUNDS = rounds ? rounds : 2
    FPAT = "[.#]"
}

BEGINFILE {
    delete IMAGE
    delete PROCESSOR
}

1 == FNR {
    for (i = 1; i <= NF; i++) PROCESSOR[i-1] = $i == "#"
    next
}

{
    for (i = 1; i <= NF; i++) IMAGE[0][FNR][i] = $i == "#"
    Y = FNR
    X = NF
}

ENDFILE {
    print sprint_image(0, 3-ROUNDS, 1-ROUNDS, Y+ROUNDS, X+ROUNDS)
    for (i = 1; i <= ROUNDS; i++) {
        n = process_image(i, 3-i, 1-i, Y+i, X+i)
        print sprint_image(i, 3-ROUNDS, 1-ROUNDS, Y+ROUNDS, X+ROUNDS)
    }
    print n
}





function process_image(i, y1, x1, y2, x2,     y, x, n, r) {
    for (y = y1; y <= y2; y++) {
        for (x = x1; x <= x2; x++) {
            n = 0
            n += get_pixel_at_iter(i-1, y-1, x-1) * 2 ** 8
            n += get_pixel_at_iter(i-1, y-1, x  ) * 2 ** 7
            n += get_pixel_at_iter(i-1, y-1, x+1) * 2 ** 6

            n += get_pixel_at_iter(i-1, y  , x-1) * 2 ** 5
            n += get_pixel_at_iter(i-1, y  , x  ) * 2 ** 4
            n += get_pixel_at_iter(i-1, y  , x+1) * 2 ** 3

            n += get_pixel_at_iter(i-1, y+1, x-1) * 2 ** 2
            n += get_pixel_at_iter(i-1, y+1, x  ) * 2 ** 1
            n += get_pixel_at_iter(i-1, y+1, x+1) * 2 ** 0

            IMAGE[i][y][x] = PROCESSOR[n]
            r += PROCESSOR[n]
        }
    }
    return r
}

function get_pixel_at_iter(i, y, x) {
    return y in IMAGE[i] && x in IMAGE[i][y] ? IMAGE[i][y][x] : (i % 2 ? PROCESSOR[0] : 0)
}

function sprint_image(i, y1, x1, y2, x2,     y, x, s) {
    for (y = y1; y <= y2; y++) {
        for (x = x1; x <= x2; x++) {
            s = s (get_pixel_at_iter(i, y, x) ? "#" : ".")
        }
        s = s "\n"
    }
    return s
}