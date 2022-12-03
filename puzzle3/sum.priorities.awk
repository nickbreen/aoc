#!/usr/bin/awk -f

BEGIN {
    FS = ""
    split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", P, "")
    for (i in P) {
        P[P[i]] = i
    }
}

{
    elf = NR
    print substr($0, 1, NF/2), substr($0, NF/2 + 1)
    for (i = 1; i <= NF/2; i++) {
        supplies[elf, 1, $i]++
    }
    for (i = NF/2 + 1; i <= NF; i++) {
        supplies[elf, 2, $i]++
    }
    for (i = 1; i <= NF; i++) {
        if (supplies[elf, 1, $i] && supplies[elf, 2, $i]) {
            print "misplaced supply", elf, $i
            X[elf] = P[$i]
        }
    }
}

END {
    for (e in X) {
        x += X[e]
        print e, X[e]
    }
    print x
}