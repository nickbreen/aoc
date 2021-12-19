#!/usr/bin/awk --file

BEGIN {
    X = 1
    Y = 2
    Z = 3
}

BEGINFILE {
    delete SCANNERS
}

$2 == "scanner" {
    SCANNER = $3
}

/^-?[0-9]+,-?[0-9]+$/ {
    split($0, ords, ",")
    SCANNERS[SCANNER][$0][X] = ords[X]
    SCANNERS[SCANNER][$0][Y] = ords[Y]
    SCANNERS[SCANNER][$0][Z] = ords[Z]
}

/^$/ {

}
