#!/usr/bin/gawk -f

BEGIN {
    E = 1
}

/[0-9]+/ { ELF[E] += $1 }

/^$/ { E++ }

END {
    asort(ELF)
    print ELF[E-2] + ELF[E-1] + ELF[E]
}