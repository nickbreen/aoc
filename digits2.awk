#!/usr/bin/awk --file

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
#
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
# 8       ?     ?     ?     7   ?      ?      4    ?      1

function find_one_four_seven_eight(digits, segments, candidate,    len, input, digit, s) {
    len = length(candidate)

    if (len == 2) digit = 1
    else if (len == 4) digit = 4
    else if (len == 3) digit = 7
    else if (len == 7) digit = 8
    else return

    split(candidate, input, "")
    found(digits, segments, digit, input)
}

function find_nine_six_zero(digits, segments, candidate,    input, digit, shared_segments, i) {
    split(candidate, input, "")

    for (i in input) if (input[i] in segments[1]) print 1, i, input[i], ++shared_segments[1]
    for (i in input) if (input[i] in segments[4]) print 4, i, input[i], ++shared_segments[4]

    print candidate, 1 ":" shared_segments[1], 4 ":" shared_segments[4]

    if (shared_segments[1] == 2 && shared_segments[4] == 3) digit = 0
    else if (shared_segments[1] == 2 && shared_segments[4] == 4) digit = 9
    else if (shared_segments[4] == 3) digit = 6
    else return

    found(digits, segments, digit, input)
}

function find_two_three_five(digits, segments, candidate,    input, digit, shared_segments, i) {
    split(candidate, input, "")

    for (i in input) if (input[i] in segments[1]) shared_segments[1]++
    for (i in input) if (input[i] in segments[6]) shared_segments[6]++

    # 3 shares 2 with 1
    if (shared_segments[1] == 2) digit = 3
    # 5 shares 5 with 6
    else if (shared_segments[6] == 5) digit = 5
    # 2 shares 4 with 6
    else if (shared_segments[6] == 4) digit = 2
    else return

    found(digits, segments, digit, input)
}

function found(digits, segments, digit, input,   i, d) {
    asort(input)
    for (i in input) {
        segments[digit][input[i]]++
        d = d input[i]
    }
    digits[d] = digit
    printf "Found %d as %s\n", digit, d
}

{
    print NR, $0

    for (i = 1; i <= 10; i++) find_one_four_seven_eight(digits, segments, $i)
    for (i = 1; i <= 10; i++) if (length($i) == 6) find_nine_six_zero(digits, segments, $i)
    for (i = 1; i <= 10; i++) if (length($i) == 5) find_two_three_five(digits, segments, $i)

    if (length(digits) != 10) exit 1

    s = ""
    for (i = 12; i <=15; i++) {
        split($i, input, "")
        asort(input)
        candidate = ""
        for (j in input) candidate = candidate input[j]
        s = s sprintf("%d", digits[candidate])

    }
    print s

    sum += s

    delete segments
    delete digits
}

function print_segments(          i, j, s) {
    for (i in segments) {
        s = ""
        for (j in segments[i]) s = s j
        print i, s
    }
}

END {
    print sum
}