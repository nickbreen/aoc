#!/usr/bin/gawk --file

BEGINFILE {
    delete INSERTION
    delete TEMPLATE
}

/^[A-Z]+$/ {
    TEMPLATE[0] = $0
}

/[A-Z]{2} -> [A-Z]/ {
    pair = substr($0, 1, 2)
    insertion = substr($0, length($0))
    INSERTION[pair] = insertion
}

ENDFILE {
    print "Template: " TEMPLATE[0]
    for (i = 1; i <= 10; i++) {
        template = TEMPLATE[i-1]
        n = length(template)
        for (j = 1; j < n; j++) {
            pair = substr(template, j, 2)
            left = substr(template, j, 1)
            right = substr(template, j+1, 1)
            insertion = INSERTION[pair]
            TEMPLATE[i] = TEMPLATE[i] left insertion
        }
        TEMPLATE[i] = TEMPLATE[i] right
        print "After step " i ": (" length(TEMPLATE[i]) ") " TEMPLATE[i]
    }

    if (ARGIND == 1) {
        expected[0] = "NNCB"
        expected[1] = "NCNBCHB"
        expected[2] = "NBCCNBBBCBHCB"
        expected[3] = "NBBBCNCCNBBNBNBBCHBHHBCHB"
        expected[4] = "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"

        for (i = 1; i <= 4; i++)
            if (TEMPLATE[i] != expected[i]) {
                print "error at " i " expected " expected[i] " got " TEMPLATE[i]
                exit 1
            }
    }

    template = TEMPLATE[10]
    delete elements
    for (i = 1; i <= length(template); i++) {
        element = substr(template, i, 1)
        elements[element]++
    }
    for (i in elements) print i " = " elements[i]

    if (ARGIND == 1) {
        if (elements["H"] != 161) {
            print "expected H = 161"
            exit 1
        }
        if (elements["B"] != 1749) {
            print "expected B = 1749"
            exit 1
        }
    }

    asort(elements)

    print elements[length(elements)] " - " elements[1] " = " (elements[length(elements)] - elements[1])
}
