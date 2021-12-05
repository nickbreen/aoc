#!/usr/bin/awk --file

NR == 1 {
    split($0, draw, ",")
    for (i in draw) foo = foo " " draw[i]
    next
}

/^$/ {
    board_index++
    row_index = 1
    next
}

{
    for (i = 1; i <= NF; i++) {
        boards[board_index][row_index][i] = $i
        board_sums[board_index] += $i
    }
    row_index++
}

END {
    for (d in draw) {
        for (b in boards) {
            for (r in boards[b]) {
                for (i in boards[b][r]) {
                    rows[b][r] += boards[b][r][i] == draw[d]
                    cols[b][i] += boards[b][r][i] == draw[d]
                    if (boards[b][r][i] == draw[d]) {
                        board_sums[b] -= draw[d]
                    }
                    if (rows[b][r] == 5 || cols[b][i] == 5) {
                        print board_sums[b] * draw[d]
                        exit
                    }
                }
            }
        }
    }
}
