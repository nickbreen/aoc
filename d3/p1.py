#!/bin/python3
import fileinput
import re

expr = re.compile("mul\\((\\d{1,3}),(\\d{1,3})\\)")

ops = []

for line in fileinput.input():
    line = line.strip()
    ops += [int(match.group(1)) * int(match.group(2)) for match in expr.finditer(line)]

print (sum(ops))