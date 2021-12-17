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
}

$1 ~ /^[0-9A-F]+$/ {
    VERSION = 0
    decode_packet(to_binary_string($1), 1)
    print "\nVERSION: " VERSION "\n\n\n"
    if ($2 && VERSION != $2) {
        print "FAIL " VERSION " was not " $2
        exit 1
    }
}

function decode_packet(packet, p) {
    print packet, p, "decode_packet packet"

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

    print "literal", bin, hex " => " strtonum(hex)
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
    print "version", p, bin, hex, dec
    VERSION += dec
    return p + 3
}

function packet_type(packet, p) {
    PACKET_TYPE = substr(packet, p, 3)
    print "type", PACKET_TYPE
    return p + 3
}

function is_literal() {
    return PACKET_TYPE == "100"
}