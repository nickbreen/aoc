#!/usr/bin/awk -f

function score(abc, xyz)
{
    return ScorePlay[xyz] + ScoreMatch[abc, xyz]
}

BEGIN {
    Win = 6
    Draw = 3

    ScorePlay["X"] = 1
    ScorePlay["Y"] = 2
    ScorePlay["Z"] = 3

    ScoreMatch["A", "Y"] = Win
    ScoreMatch["B", "Z"] = Win
    ScoreMatch["C", "X"] = Win

    ScoreMatch["A", "X"] = Draw
    ScoreMatch["B", "Y"] = Draw
    ScoreMatch["C", "Z"] = Draw

    MyScore = 0
}

{
    MyScore += score($1, $2)
}

END {
    print MyScore
}