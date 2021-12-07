#!/usr/bin/awk --file

BEGIN {
    FPAT = "[0-9]+"
}

{
    for (i = 1; i <=NF; i++) {
        count++
        crabs[$i]++
        max_pos = max_pos < $i ? $i : max_pos
    }
}

END {
    min_fuel = max_pos^2 * count # maximum possible fuel consumption
    for (p = 0; p <= max_pos; p++) {
        for (c in crabs) {
            dist = abs(c - p)
            for (i = dist; i; i--) fuel[p] += i * crabs[c] # to lazy to figure out the formula
#            print "Pos", p, "Crabs", crabs[c] "@" c, "Fuel", abs(c - p) * crabs[c]
        }
#        print "Fuel", p, fuel[p]
        min_fuel = fuel[p] < min_fuel ? fuel[p] : min_fuel
    }
    print min_fuel
}

function abs(x) {
    return x > 0 ? x : -x
}
