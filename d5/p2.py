import fileinput

before_rules = {}
after_rules = {}

mid = 0


def complies(seq):
    for i in range(1, len(seq)):
        if seq[i] in before_rules and before_rules[seq[i]].intersection(seq[:i]):
            return -1
    for i in range(len(seq)-1):
        if seq[i] in after_rules and after_rules[seq[i]].intersection(seq[i:]):
            return 1
    return 0


def sort(seq):
    for i in range(1, len(seq)):
        if seq[i] in before_rules and before_rules[seq[i]].intersection(seq[:i]):
            seq[i], seq[i-1] = seq[i-1], seq[i]
            return seq
    for i in range(len(seq)-1):
        if seq[i] in after_rules and after_rules[seq[i]].intersection(seq[i:]):
            seq[i], seq[i+1] = seq[i+1], seq[i]
            return seq
    return seq

for line in fileinput.input():
    rule = line.strip().split("|")
    if len(rule) >= 2:
        if rule[0] not in before_rules:
            before_rules[rule[0]] = {rule[1]}
        else:
            before_rules[rule[0]].add(rule[1])
        if rule[1] not in after_rules:
            after_rules[rule[1]] = {rule[0]}
        else:
            after_rules[rule[1]].add(rule[0])
        continue
    if line.strip() == "":
        continue
    seq = line.strip().split(",")
    if complies(seq) == 0:
        continue
    while complies(seq) != 0:
        print ("s ", seq)
        seq = sort(seq)
        print ("s'", seq)
    mid += int(seq[len(seq)//2])

print (mid)

