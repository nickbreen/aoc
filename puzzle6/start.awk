#!/usr/bin/awk -f

{
    msg=$1
    n=length(msg)

    for (i=14; i <= n; i++) {
        s = substr(msg, i-13, 14)
        split(s, w, "")
        delete a
        for (j in w) {
            a[w[j]] = j
        }
        x = 0
        for (j in a) {
            x++
        }
        if (x != 14) {
            print "not a start-of-message", i, s, x
            continue
        }
        print "start-of-message", i, s, x
        if ($3 && i == $3) {
            print i, "correct"
        } else if ($3 && i != $3) {
            print i, "expected", $3
        }
        print i
        next
    }
}
