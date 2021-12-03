#!/usr/bin/awk --file

BEGIN {
    FS = ""
}

{
    for (i = 1; i <= NF; i = i + 1) {
        digits[i] += $i ? 1 : -1;
    }
}

END {
    for (i in digits) {
        filter = filter "" (0 <= digits[i] ? 1 : 0)
    }
    print filter
}