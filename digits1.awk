#!/usr/bin/awk --file

{
    print $12, $13, $14, $15
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