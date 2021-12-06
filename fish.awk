#!/usr/bin/awk --file

days = days ? days : 18

BEGIN {
    FPAT = "[0-9]+"
}

{
    for (i = 1; i <= NF; i++) fish[0][$i]++
    print_fish(fish, 0)
}

END {
    for (d = 1; d <= days; d++) {
        for (f = 0; f < 8; f++) {
            fish[d][f] = fish[d-1][f+1]
        }
        fish[d][6] += fish[d-1][0]  # reset the old fish
        fish[d][8] = fish[d-1][0]  # add the new fish
    }

    for (f in fish[days]) fish_count+=fish[days][f]
    print fish_count
}

function print_fish(fish, d,     f, s) {
    for (f = 0; f < 9; f++) s = s sprintf("Fish[%3d][%d] = %6d\n", d, f, fish[d][f])
    print s
}
