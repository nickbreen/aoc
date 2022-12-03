#!/usr/bin/awk -f

BEGIN {
    FS = ""
    split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", P, "")
    for (i in P) {
        P[P[i]] = i
    }
}

{
    group = 1 + int((NR-1)/3)
    elf = NR % 3
    print group, elf
    for (i = 1; i <= NF; i++) {
        supplies[group, elf, $i]++
    }
    for (i = 1; i <= NF; i++) {
        if (supplies[group, 1, $i] && supplies[group, 2, $i] && supplies[group, 0, $i]) {
            print "badge", group, elf, $i
            X[group] = P[$i]
        }
    }
}

END {
    for (g in X) {
        x += X[g]
        print e, X[g]
    }
    print x
}