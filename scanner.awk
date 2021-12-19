#!/usr/bin/awk --file

BEGIN {
    X = 1
    Y = 2
    Z = 3
}

BEGINFILE {
    delete SCANNERS
    delete BEACONS
}

$2 == "scanner" {
    SCANNER = $3
    if ($3 == 0) {
        SCANNERS[SCANNER][X] = 0
        SCANNERS[SCANNER][Y] = 0
        SCANNERS[SCANNER][Z] = 0
    }
}

/^-?[0-9]+,-?[0-9]+$/ {
    split($0, ords, ",")
    BEACONS[SCANNER][$0][X] = ords[X]
    BEACONS[SCANNER][$0][Y] = ords[Y]
    BEACONS[SCANNER][$0][Z] = ords[Z]
}

/^$/ {

}
