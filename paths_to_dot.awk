#!/usr/bin/awk --file

BEGIN {
    FS = "-"
}

BEGINFILE {
    print "graph " gsub(/\./, "_", FILENAME) " {"
}

{
    print "\t" $1 " -- " $2 ";"
}

ENDFILE {
    print "\t{ rank=min; start }"
    print "\t{ rank=max; end }"
    print "}"

}
