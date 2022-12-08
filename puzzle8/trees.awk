#!/usr/bin/awk -f

function max(a, b) {
    return a < b ? b : a
}

{
    C=length($1)
    R=NR
    split($1, trees, "")
    for (c = 1; c <= C; c++) {
        Trees[R, c] = trees[c]
        MaxNorth[R, c] = max(Trees[R-1, c], MaxNorth[R-1, c])
    }
    for (c = 1; c <= C; c++) {
        MaxWest[R, c] = max(Trees[R, c-1], MaxWest[R, c-1])
    }
    for (c = C; 0 < c; c--) {
        MaxEast[R, c] = max(Trees[R, c+1], MaxEast[R, c+1])
    }
}

END {
    for (r = R; 0 < r; r--) {
        for (c = 1; c <= C; c++) {
            MaxSouth[r, c] = max(Trees[r+1, c], MaxSouth[r+1, c])
        }
    }

#    print_matrix(Trees, R, C)
#    printf "\nNorth\n"
#    print_matrix(MaxNorth, R, C)
#    printf "\nEast\n"
#    print_matrix(MaxEast, R, C)
#    printf "\nSouth\n"
#    print_matrix(MaxSouth, R, C)
#    printf "\nWest\n"
#    print_matrix(MaxWest, R, C)
#    printf "\n"

    for (r = 1; r <= R; r++) {
        for (c = 1; c <= C; c++) {
            if (Vis[r, c] = r == 1 || c == 1 || r == R || c == C) {
                continue
            }
#            print "tree", r "," c, "N" MaxNorth[r, c] "<" Trees[r, c], "E" MaxEast[r, c] "<" Trees[r, c], "S" MaxSouth[r, c] "<" Trees[r, c], "W" MaxWest[r, c] "<" Trees[r, c]
            if (Vis[r, c] = MaxNorth[r, c] < Trees[r, c]) {
#                print "seen from north", MaxNorth[r, c]
                continue
            }
            if (Vis[r, c] = MaxEast[r, c] < Trees[r, c]) {
#                print "seen from east", MaxEast[r, c]
                continue
            }
            if (Vis[r, c] = MaxSouth[r, c] < Trees[r, c]) {
#                print "seen from south", MaxSouth[r, c]
                continue
            }
            if (Vis[r, c] = MaxWest[r, c] < Trees[r, c]) {
#                print "seen from west", MaxWest[r, c]
                continue
            }
        }
    }
#    print_matrix(Vis, R, C)

    for (r = 1; r <= R; r++) {
        for (c = 1; c <= C; c++) {
            n += Vis[r, c]
        }
    }
    print n
}

function print_matrix(m, nr, nc,    r, c) {
    for (r = 1; r <= nr; r++) {
        for (c = 1; c <= nc; c++) {
            printf m[r, c]
        }
        printf "\n"
    }

}

