#!/usr/bin/awk --file

BEGIN {
    FPAT = "-?[0-9]+"
}

BEGINFILE {
    SUB_X = 0
    SUB_Y = 0
    delete POS_Y
    delete POS_X
}

{
    TARGET_X1 = $1 < $2 ? $1 : $2
    MIN_X = POSITION["x"]
    MIN_X = MIN_X < TARGET_X1 ? MIN_X : TARGET_X1
    TARGET_X2 = $2 < $1 ? $1 : $2
    MAX_X = POSITION["x"]
    MAX_X = TARGET_X2 < MAX_X ? MAX_X : TARGET_X2

    TARGET_Y1 = $3 < $4 ? $3 : $4
    MIN_Y = POSITION["y"]
    MIN_Y = MIN_Y < TARGET_Y1 ? MIN_Y : TARGET_Y1
    TARGET_Y2 = $4 < $3 ? $3 : $4
    MAX_Y = POSITION["y"]
    MAX_Y = TARGET_Y2 < MAX_Y ? MAX_Y : TARGET_Y2

    print MIN_X, MAX_X, MIN_Y, MAX_Y, $0, $1 ".." $2, $3 ".." $4

    print sprint_area()
}

ENDFILE {
    MIN_DX = 1  # must fire forwards
    MIN_DY = TARGET_Y2  # need to fire up to get highest arc
    MAX_DX = 4 * (TARGET_X2 - TARGET_X1)  # estimated maximum rate before passing over target area
    MAX_DY = 8 * (TARGET_Y2 - TARGET_Y1) # estimated maximum rate before passing over target area

    MAX_Y = MAX_DY * MAX_DY / 2

    MAX_STEPS = abs(TARGET_Y2) < abs(TARGET_X2) ? abs(TARGET_X2) : abs(TARGET_Y2)

    MAX_STEPS *= 8

    print "Finding firing solution for dy=" MIN_DY ".." MAX_DY, "; dx=" MIN_DX ".." MAX_DX, "over", MAX_STEPS, "steps"

    N = 0

    MAX_POS_Y = SUB_Y
    for (dy = MIN_DY; dy <= MAX_DY; dy++) {
        for (dx = MIN_DX; dx <= MAX_DX; dx++) {
            delete POS_Y
            delete POS_Y
            POS_Y[0] = SUB_Y
            POS_X[0] = SUB_X
            DY = dy
            DX = dx
            for (i = 1; i <= MAX_STEPS; i++) {
                POS_Y[i] = POS_Y[i-1] + DY--
                POS_X[i] = POS_X[i-1] + DX
                if (DX < 0) DX++
                else if (0 < DX) DX--
                max_pos_y = POS_Y[i] < max_pos_y ? max_pos_y : POS_Y[i]
                #if (past_target(POS_Y[i], POS_X[i])) break;
                if (in_target(POS_Y[i], POS_X[i])) break;
            }
            #print "Testing firing solution", dy "," dx, "over", i, "steps"
            #print sprint_area(POS_Y, POS_X)
            if (in_target(POS_Y[i], POS_X[i])) {
                MAX_POS_Y = max_pos_y < MAX_POS_Y ? MAX_POS_Y : max_pos_y
                print "Firing solution found", dy "," dx, "max Y " MAX_POS_Y
                N++
            }
        }
    }
    print N
}

function sprint_area(py, px,   y, x, s, pp, i) {
    for (i in py) pp[py[i]][px[i]]++
    for (x in px) ppx[px[x]]++
    for (y = MAX_Y; MIN_Y <= y; y--) {
        for (x = MIN_X; x <= MAX_X; x++) {
            if (y in pp && x in pp[y]) s = s "#"
            else if (in_target(y, x)) s = s "T"
            else if (in_sub(y, x)) s = s "S"
            else s = s "."
        }
        s = s "\n"
    }
    return s
}

function in_target(y, x) {
    return TARGET_Y1 <= y && y <= TARGET_Y2 && TARGET_X1 <= x && x <= TARGET_X2
}

function past_target(y, x) {
    return y < TARGET_Y2 || TARGET_X2 < x
}

function in_sub(y, x) {
    return SUB_Y == y && SUB_X == x
}

function abs(v) {
    v += 0;
    return v < 0 ? -v : v
}