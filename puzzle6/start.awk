#!/usr/bin/awk -f

{
    msg=$1
    n=length(msg)

    for (i=4; i <= n; i++) {
        s = substr(msg, i-3, 4)
        split(s, w, "")
        delete a
        for (j in w) {
            a[w[j]] = j
        }
        x = 0
        for (j in a) {
            x++
        }
        if (x != 4) {
            print "not a start-of-packet", i, s, x
            continue
        }
        print "start-of-packet", i, s, x
        if ($2 && i == $2) {
            print i, "correct"
        } else if ($2 && i != $2) {
            print i, "expected", $2
        }
        print i
        next
    }
}
