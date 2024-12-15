#!/bin/python3
import fileinput
import re

ops_re = re.compile("(do(?:n't)?)\\(\\)|(mul)\\((\\d{1,3}),(\\d{1,3})\\)")

ops = []

for line in fileinput.input():
    line = line.strip()
    ops += [match.groups() for match in ops_re.finditer(line)]

print (ops)

n = 0
do = True

for op in ops:
    if op[0] == "do":
        do = True
    elif op[0] == "don't":
        do = False
    elif op[1] == "mul" and do:
        n += int(op[2]) * int(op[3])

print (n)