#!/usr/bin/awk --file

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
# 8       ?     ?     ?     7   9      6      4    ?      7

{
    print "input", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10


    print "output", $12, $13, $14, $15
    for (i = 12; i <= 15; i++) {
        print $i, length($i)
        switch (length($i)) {
            case 2: # 1
            case 4: # 4
            case 3: # 7
            case 7: # 8
                count++
        }
    }
}

END {
    print count
}