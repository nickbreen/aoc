#!/usr/bin/awk --file

NR == 1 {
    split($0, draw, ",")
    for (i in draw) foo = foo " " draw[i]
    next
}

/^$/ {
    board_index++
    row_index = 0
    next
}

{
    row_index++
    for (i = 1; i <= NF; i++) {
        boards[board_index][row_index][i] = $i
    }
}

END {
    for (d in draw) {
        for (b in boards) {
            for (r in boards[b]) {
                for (i in boards[b][r]) {
                    rows[b][r] += boards[b][r][i] == draw[d]
                    cols[b][i] += boards[b][r][i] == draw[d]
                    if (rows[b][r] == 5 || cols[b][i] == 5) {
                        print_board(boards[b])
                        exit
                    }
                }
            }
        }
    }
}

function print_board(rows,    r, row, i) {
    for (r in rows) {
        row = ""
        for (i in rows[r]) {
            row = row " " sprintf("%2d", rows[r][i])
        }
        print row
    }
}