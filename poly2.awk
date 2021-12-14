#!/usr/bin/awk --file

BEGIN {
    ROUNDS = rounds ? rounds : 10
    FPAT = "[A-Z]"
}

BEGINFILE {
    delete INSERT
    delete PAIR
    delete ELEMENT
}

FNR == 1 {
    for (i = 1; i < NF; i++) {
        j = i + 1
        PAIR[$i $j]++
        ELEMENT[$i]++
    }
    ELEMENT[$i]++
}

2 < FNR {
    INSERT[$1 $2] = $3
}

ENDFILE {

    for (i = 1; i <= ROUNDS; i++) {
        delete new_pair
        for (pair in PAIR) {
            if (pair in INSERT) {
                left = substr(pair, 1, 1)
                right = substr(pair, 2)
                insert = INSERT[pair]
                # add the inserted element the number of times the insertion pair occurs
                ELEMENT[insert] += PAIR[pair]
                # remove all this insertion pair
                new_pair[pair] -= PAIR[pair]
                # add the new insertion pairs
                new_pair[left insert] += PAIR[pair]
                new_pair[insert right] += PAIR[pair]

            }
        }
        for (pair in new_pair) {
            PAIR[pair] += new_pair[pair]
        }

    }

    asort(ELEMENT)

    print FILENAME, ELEMENT[length(ELEMENT)] " - " ELEMENT[1] " = " (ELEMENT[length(ELEMENT)] - ELEMENT[1])
}
