#!/usr/bin/awk --file

BEGIN {
    FS = ""
}

{
    for (i = 1; i <= NF; i = i + 1) {
        digits[i] += $i ? 1 : -1;
    }
}

END {
    for (i in digits) {
        gamma += digits[i] > 0 ? (2 ^ (NF - i)) : 0
    }
    for (i in digits) {
        epsilon += digits[i] < 0 ? (2 ^ (NF - i)) : 0
    }

    print "gamma", gamma, "epsilon", epsilon, "power consumption", gamma * epsilon
}