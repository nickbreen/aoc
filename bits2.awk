#!/usr/bin/gawk --file

BEGIN {
    DIGITS["0"] = "0000"
    DIGITS["1"] = "0001"
    DIGITS["2"] = "0010"
    DIGITS["3"] = "0011"
    DIGITS["4"] = "0100"
    DIGITS["5"] = "0101"
    DIGITS["6"] = "0110"
    DIGITS["7"] = "0111"
    DIGITS["8"] = "1000"
    DIGITS["9"] = "1001"
    DIGITS["A"] = "1010"
    DIGITS["B"] = "1011"
    DIGITS["C"] = "1100"
    DIGITS["D"] = "1101"
    DIGITS["E"] = "1110"
    DIGITS["F"] = "1111"

    DIGITS["0000"] = "0"
    DIGITS["0001"] = "1"
    DIGITS["0010"] = "2"
    DIGITS["0011"] = "3"
    DIGITS["0100"] = "4"
    DIGITS["0101"] = "5"
    DIGITS["0110"] = "6"
    DIGITS["0111"] = "7"
    DIGITS["1000"] = "8"
    DIGITS["1001"] = "9"
    DIGITS["1010"] = "A"
    DIGITS["1011"] = "B"
    DIGITS["1100"] = "C"
    DIGITS["1101"] = "D"
    DIGITS["1110"] = "E"
    DIGITS["1111"] = "F"

    OPS["000"] = "+"
    OPS["001"] = "*"
    OPS["010"] = "min"
    OPS["011"] = "max"
    OPS["100"] = "lit"
    OPS["101"] = ">"
    OPS["110"] = "<"
    OPS["111"] = "="

    PROCINFO["sorted_in"] = "@ind_str_asc"
}

$1 ~ /^[0-9A-F]+$/ {
    delete STACK
    STACK_PTR = 0
    decode_packet(to_binary_string($1), 1)

    do {
        print sprint_stack()
        switch (STACK[STACK_PTR]) {
            case "000":
                print "SUM", STACK[STACK_PTR+1], STACK[STACK_PTR+2]
                STACK[STACK_PTR] = STACK[STACK_PTR+1] + STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+1]
                break
            case "001":
                print "MUL", STACK[STACK_PTR+1], STACK[STACK_PTR+2]
                STACK[STACK_PTR] = STACK[STACK_PTR+1] * STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+1]
                break
            case "010":
                print "MIN", STACK[STACK_PTR+1], STACK[STACK_PTR+2], STACK[STACK_PTR+3]
                STACK[STACK_PTR] = -log(0)
                for (i = STACK_PTR + 3; STACK_PTR < i; i--) {
                    print "min(" i ")", STACK[STACK_PTR], STACK[i]
                    STACK[STACK_PTR] = STACK[STACK_PTR] < STACK[i] ? STACK[STACK_PTR] : STACK[i]
                    delete STACK[i]
                }
                break
            case "011":
                print "MAX", STACK[STACK_PTR+1], STACK[STACK_PTR+2], STACK[STACK_PTR+3]
                STACK[STACK_PTR] = log(0)
                for (i = STACK_PTR + 3; STACK_PTR < i; i--) {
                    print "max(" i ")", STACK[STACK_PTR], STACK[i]
                    STACK[STACK_PTR] = STACK[i] < STACK[STACK_PTR] ? STACK[STACK_PTR] : STACK[i]
                    delete STACK[i]
                }
                break
            case "100":
                print "LIT", STACK[STACK_PTR+1]
                STACK[STACK_PTR] = STACK[STACK_PTR+1]
                delete STACK[STACK_PTR+1]
                break
            case "101":
                print "GT", STACK[STACK_PTR+1], STACK[STACK_PTR+2]
                STACK[STACK_PTR] = STACK[STACK_PTR+1] > STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+1]
                break
            case "110":
                print "LT", STACK[STACK_PTR+1], STACK[STACK_PTR+2]
                STACK[STACK_PTR] = STACK[STACK_PTR+1] < STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+1]
                break
            case "111":
                print "EQ", STACK[STACK_PTR+1], STACK[STACK_PTR+2]
                STACK[STACK_PTR] = STACK[STACK_PTR+1] == STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+2]
                delete STACK[STACK_PTR+1]
                break
            default:
        }
        asort(STACK, STACK, "isort")
        STACK_PTR--
    } while (0 < STACK_PTR)

    if ($2 && STACK[1] != $2) {
        print "FAIL " STACK[1] " (" typeof(STACK[1]) ") was not " $2 " (" typeof($2) ") " $1
        print
        exit 1
    } else {
        printf "PASS %d %x\n", STACK[1], STACK[1]
    }
}

function isort(i1, v1, i2, v2) {
    return i1 - i2
}

function sprint_stack(   i, s) {
    for (i in STACK) s = s i ":" (STACK[i] in OPS ? OPS[STACK[i]] : STACK[i]) (i == STACK_PTR ? "*" : "") "; "
    return s
}

function decode_packet(packet, p) {
    print packet, p "/" length(packet), "decode_packet packet"

    p = packet_version(packet, p)
    p = packet_type(packet, p)

    if (is_literal()) {
        p = decode_literal(packet, p)
    }
    else
    {
        p = decode_operator(packet, p)
    }

    return p
}

function decode_literal(packet, p,     bin, hex) {
    hex = "0X"
    while (substr(packet, p++, 1) == "1") {
        digits = substr(packet, p, 4)
        bin = bin " " digits
        hex = hex DIGITS[digits]
        p += 4
    }
    digits = substr(packet, p, 4)
    bin = bin " " digits
    hex = hex DIGITS[digits]
    p += 4

    #print "literal", bin, hex " => " strtonum(hex), "pushing on to stack at " (STACK_PTR + 1)
    STACK[++STACK_PTR] = strtonum(hex)
    return p
}

function decode_operator(packet, p,     length_type_id) {
    length_type_id = substr(packet, p, 1)
    return (length_type_id == "0") ? decode_bit_length(packet, p+1) : decode_packet_count(packet, p+1)
}

function decode_bit_length(packet, p,     bit_length, len, q) {
    #print "IN  0" substr(packet, p, 15)
    #print "     111222233334444"

    bit_length[1] = "0" substr(packet, p, 3)
    p += 3
    bit_length[2] = substr(packet, p, 4)
    p += 4
    bit_length[3] = substr(packet, p, 4)
    p += 4
    bit_length[4] = substr(packet, p, 4)
    p += 4

    #print "OUT " bit_length[1] bit_length[2] bit_length[3] bit_length[4]
    len = "0X" DIGITS[bit_length[1]] DIGITS[bit_length[2]] DIGITS[bit_length[3]] DIGITS[bit_length[4]]
    #print "bit length", len " => " strtonum(len)
    len = strtonum(len)
    #print "decoding from " p " for " len " to " p + len
    #print packet
    #print "VVVTTTILLLLLLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBBBBBB"
    #print "12345678901234567890123456789012345678901234567890"
    #print "00000000011111111112222222222333333333344444444445"
    len = p + len
    while (p < len)
        p = decode_packet(packet, p)

    return p
}

function decode_packet_count(packet, p,   packet_counts, packet_count, i) {
    packet_counts[1] = "0" substr(packet, p, 3)
    p += 3
    packet_counts[2] = substr(packet, p, 4)
    p += 4
    packet_counts[3] = substr(packet, p, 4)
    p += 4
    len = "0X" DIGITS[packet_counts[1]] DIGITS[packet_counts[2]] DIGITS[packet_counts[3]]
    packet_count = strtonum(len)

    for (i = 1; i <= packet_count; i++)
        p = decode_packet(packet, p)

    return p
}

function to_binary_string(hex,   digits, binary, i)
{
    split(hex, digits, "")
    for (i = 1; i <= length(digits); i++) {
        binary = binary DIGITS[digits[i]]
    }
    return binary
}

function packet_version(packet, p,    bin, hex, dec) {
    bin = substr(packet, p, 3)
    hex = "0X" DIGITS["0" bin]
    dec = strtonum(hex)
    #print "version", p, bin, hex, dec
    VERSION += dec
    return p + 3
}

function packet_type(packet, p,    type) {
    type = substr(packet, p, 3)
    STACK[++STACK_PTR] = type
    #print "type", type, OPS[type]
    return p + 3
}

function is_literal() {
    return STACK[STACK_PTR] == "100"
}