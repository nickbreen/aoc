#!/usr/bin/awk -f

BEGIN {
    Total = 70000000
    Required = 30000000
}

$1 == "$" {
    print "command", $0
    if ($2 == "cd") {
        if ($3 == "/") {
            delete Cwd
            ICwd = 1
            Cwd[ICwd] = ""
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

    print "Used", Sizes["/"]
    print "Available", Total - Sizes["/"]

    required = Required - (Total - Sizes["/"])
    print "required", required

    candidateSize = Total

    for (d in Sizes) {
        if (required <= Sizes[d]) {
            print "Del candidate", d, Sizes[d]
            if (Sizes[d] < candidateSize) {
                print "New best candidate", d, Sizes[d]
                candidateSize = Sizes[d]
                candidate = d
            }
        }
    }
    print "delete", candidate, candidateSize
}

function cwd(n,       i, s) {
    for (i = 1; i <= (n ? n : ICwd); i++) {
        s = s Cwd[i] "/"
    }
    return s
}

