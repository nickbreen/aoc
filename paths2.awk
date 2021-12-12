#!/usr/bin/awk --file

BEGIN {
    FS = "-"
}

BEGINFILE {
    delete TREE
    PATHS = 0
}

$1 == "start" || $2 == "end" {
    TREE[$1][++TREE[$1][0]] = $2
    next
}

$2 == "start" || $1 == "end" {
    TREE[$2][++TREE[$2][0]] = $1
    next
}

{
    TREE[$1][++TREE[$1][0]] = $2
    TREE[$2][++TREE[$2][0]] = $1
}

ENDFILE {
    paths("start", "end")
    print FILENAME, PATHS
}

function paths(from, to, visited,      i) {
    visited[from]++

    if (from == to) {
        visited[from]--
        PATHS++
        return
    } else {
        for (i = 1; i <= TREE[from][0]; i++)
            if (can_visit(TREE[from][i], visited)) {
                paths(TREE[from][i], to, visited)
            }
    }
    visited[from]--
}

function can_visit(cave, visited,    c, n) {
    for (c in visited) if (c ~ /[a-z]+/ && visited[c] == 2) n++
    return cave ~ /[A-Z]+/ || !visited[cave] || n == 0
}

