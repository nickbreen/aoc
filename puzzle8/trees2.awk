#!/usr/bin/awk -f

function max(a, b) {
    return a < b ? b : a
}

function see(myHeight, theirHeight, theyCanSee) {
    return theirHeight < myHeight ? theyCanSee + 1 : 1
}

{
    C=length($1)
    R=NR
    split($1, trees, "")
    for (c = 1; c <= C; c++) {
        Trees[R, c] = trees[c]
    }
}

END {
    for (r = 1; r <= R; r++) {
        for (c = 1; c <= C; c++) {
            SeeNorth[r, c] = r == 1 ? 0 : see(Trees[r, c], Trees[r-1, c], SeeNorth[r-1, c])
            SeeWest[r, c] = c == 1 ? 0 : see(Trees[r, c], Trees[r, c-1], SeeWest[r, c-1])
        }
    }

    for (r = R; 0 < r; r--) {
        for (c = C; 0 < c; c--) {
            SeeEast[r, c] = c == C ? 0 : see(Trees[r, c], Trees[r, c+1], SeeEast[r, c+1])
            SeeSouth[r, c] = r == R ? 0 : see(Trees[r, c], Trees[r+1, c], SeeSouth[r+1, c])
        }
    }

    for (r = 1; r <= R; r++) {
        for (c = 1; c <= C; c++) {
            SeeAll[r, c] = SeeNorth[r, c] * SeeSouth[r, c] * SeeWest[r, c] * SeeEast[r, c]
        }
    }

    print "Trees"
    print_matrix(Trees, R, C)
    print "See North"
    print_matrix(SeeNorth, R, C)
    print "See South"
    print_matrix(SeeSouth, R, C)
    print "See East"
    print_matrix(SeeEast, R, C)
    print "See West"
    print_matrix(SeeWest, R, C)
    print "See All"
    print_matrix(SeeAll, R, C)

    for (r = 1; r <= R; r++) {
        for (c = 1; c <= C; c++) {
            n = max(n, SeeAll[r, c])
        }
    }
    print n
}

function print_matrix(m, nr, nc,    r, c) {
    for (r = 1; r <= nr; r++) {
        for (c = 1; c <= nc; c++) {
            printf "%3d", m[r, c]
        }
        printf "\n"
    }
}

