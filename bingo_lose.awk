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
            if (b in wins) continue
            for (r in boards[b]) {
                for (i in boards[b][r]) {
                    rows[b][r] += boards[b][r][i] == draw[d]
                    cols[b][i] += boards[b][r][i] == draw[d]
                    if (boards[b][r][i] == draw[d]) {
                        board_sums[b] -= draw[d]
                    }
                    if (rows[b][r] == 5 || cols[b][i] == 5) {
                        wins[b] = d
                        last_d = d
                        board_index--
                        break
                    }
                }
            }
        }
    }
    for (b in boards) {
        if (wins[b] == last_d) {
            print "board", b, "won at draw", wins[b], "(" draw[wins[b]] ")", board_sums[b], board_sums[b] * draw[wins[b]]
        }
    }
}
