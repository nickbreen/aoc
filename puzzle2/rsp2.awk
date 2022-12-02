#!/usr/bin/awk -f

BEGIN {
    Win = 6
    Draw = 3
    Loss = 0

    Rock = 1
    Paper = 2
    Scissors = 3

    Score["A", "X"] = Scissors + Loss
    Score["A", "Y"] = Rock + Draw
    Score["A", "Z"] = Paper + Win

    Score["B", "X"] = Rock + Loss
    Score["B", "Y"] = Paper + Draw
    Score["B", "Z"] = Scissors + Win

    Score["C", "X"] = Paper + Loss
    Score["C", "Y"] = Scissors + Draw
    Score["C", "Z"] = Rock + Win

    MyScore = 0
}

{
    MyScore += Score[$1, $2]
}

END {
    print MyScore
}