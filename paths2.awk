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

    if (from == to) {
        #print "PATH", sprint_arr(path, 1, p+1)
        visited[from]--
        PATH++
        return
    } else {
        for (i = 1; i <= TREE[from][0]; i++)
            if (can_visit(TREE[from][i], visited)) {
                paths(TREE[from][i], to, p+1, path, visited)
            }
    }
    visited[from]--
}

function sprint_arr(arr, i, j,    s) {
    while (i <= j) s = s (s ? "," : "") arr[i++]
    return s
}

function can_visit(cave, visited,    c, n) {
    for (c in visited) if (c ~ /[a-z]+/ && visited[c] == 2) n++
    return cave ~ /[A-Z]+/ || !visited[cave] || n == 0
}

