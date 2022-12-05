#!/usr/bin/awk -f

/\[/ {
    InitialStacks[NR] = $0
}

/^( *[0-9])+$/ {
    StackCount = NF
    print "stacks", NF
    for (i = NR-1; 0 < i; i--) {
        for (s = 1; s <= NF; s++) {
            f=(s-1)*4+1
            crate = substr(InitialStacks[i], f, 3)
            if (!match(crate, /[A-Z]/)) continue
            Crates[s, ++Stacks[s]] = crate
            print "crate", s, Stacks[s], Crates[s, Stacks[s]]
        }
    }
}

/^$/ {
    printStacks()
}

$1 == "move" {
    n = $2
    from = $4
    to = $6
    print $0
    for (i = 1; i <= n; i++) {
        assert(0 < Stacks[from], "cannot pop off empty stack")
        Crates[to, ++Stacks[to]] = Crates[from, Stacks[from]--]
    }

    printStacks(from, to, n)
}

END {
    for (s = 1; s <= StackCount; s++) {
        printf substr(Crates[s, Stacks[s]], 2, 1)
    }
    printf "\n"
}

function printStacks(from, to, n) {
    for (s = 1; s <= StackCount; s++) {
        printf s " "
        for (c = 1; c <= Stacks[s]; c++) {
            printf Crates[s, c] " "
        }
        if (s == from) printf " (" n ")-> "
        if (s == to) printf " <-(" n ") "
        printf "\n"
    }
}





function assert(condition, string)
{
    if (! condition) {
        printf("%s:%d: assertion failed: %s\n",
            FILENAME, FNR, string) > "/dev/stderr"
        _assert_exit = 1
        exit 1
    }
}

END {
    if (_assert_exit)
        exit 1
}
