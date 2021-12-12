#!/usr/bin/awk --file

BEGIN {
    FS = "-"
}

BEGINFILE {
    delete TREE
    delete PATHS
    PATH = 0
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
    print FILENAME, PATH
}

function paths(from, to, p, path, visited,      i, s) {
    path[p+1] = from
    visited[from]++

    for (i = 1; i <= p; i++) s = s "   "
    print s sprint_arr(path, 1, p+1)

    if (from == to) {
        print "PATH", sprint_arr(path, 1, p+1)
        delete visited[from]
        PATH++
        return
    } else {
        for (i = 1; i <= TREE[from][0]; i++)
            if (can_visit(TREE[from][i], visited)) {
                paths(TREE[from][i], to, p + 1, path, visited)
            }
    }
    delete visited[from]
}

function sprint_arr(arr, i, j,    s) {
    while (i <= j) s = s (s ? "," : "") arr[i++]
    return s
}

function can_visit(cave, visited) {
    return cave ~ /[A-Z]+/ || !visited[cave]
}
