#!/usr/bin/awk -f

win = 6
draw = 3

score_play["X"] = 1
score_play["Y"] = 2
score_play["Z"] = 3

score_match["A", "Y"] = win
score_match["B", "Z"] = win
score_match["C", "X"] = win

score_match["A", "X"] = draw
score_match["B", "Y"] = draw
score_match["C", "Z"] = draw

function score(abc, xyz)
{
    return score_play[xyz] + score_match[abc, xyz]
}

BEGIN {
    my_score = 0
}

{
    my_score += score($1, $2)
    print my_score
}