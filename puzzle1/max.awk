#!/usr/bin/awk -f

/[0-9]+/ { ELF += $1 }

/^$/ { ELF_MAX = ELF_MAX > ELF ? ELF_MAX : ELF; ELF = 0 }

END { print ELF_MAX }