#!/usr/bin/awk -f

BEGIN {
}

$1 == "$" {
    print "command", $0
    if ($2 == "cd") {
        if ($3 == "/") {
            delete Cwd
            ICwd = 0
        } else if ($3 == "..") {
            delete Cwd[ICwd--]
        } else {
            Cwd[++ICwd] = $3
        }
    }
    print(cwd())
    next
}

$1 ~ /[0-9]+/ {
    print "file", $1, $2
    for (i = ICwd; 0 < i; i--) {
        Sizes[cwd(i)] += $1
    }
}

$1 == "dir "{
    print "dir", $2
}

END {
    for (d in Sizes) {
        print "All Sizes", d, Sizes[d]
    }

    for (d in Sizes) {
        if (Sizes[d] < 100000) {
            print "Sizes < 100k", d, Sizes[d]
            sum += Sizes[d]
        }
    }
    print sum
}

function cwd(n,       i, s) {
    s = "/"
    for (i = 1; i <= (n ? n : ICwd); i++) {
        s = s Cwd[i] "/"
    }
    return s
}

