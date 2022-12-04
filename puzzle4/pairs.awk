#!/usr/bin/awk -f

BEGIN {
    FS = ","
}

{
    split($1, Elf1Range, "-")
    split($2, Elf2Range, "-")
    if ( Elf1Range[1] <= Elf2Range[1] && Elf2Range[2] <= Elf1Range[2] || Elf2Range[1] <= Elf1Range[1] && Elf1Range[2] <= Elf2Range[2] ) {
        Contained++
    }

    if ( Elf1Range[1] <= Elf2Range[1] && Elf2Range[1] <= Elf1Range[2] || Elf2Range[1] <= Elf1Range[1] && Elf1Range[1] <= Elf2Range[2] ) {
        Overlaped++
    }

}

END {
    print Contained
    print Overlaped
}