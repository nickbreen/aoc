#!/usr/bin/gawk --file

BEGIN {
  FPAT = "."
  BLOCK["("] = ")"
  BLOCK["["] = "]"
  BLOCK["{"] = "}"
  BLOCK["<"] = ">"

  COST[")"] = 1
  COST["]"] = 2
  COST["}"] = 3
  COST[">"] = 4


}

{
  STACK_PTR = 0
  for (i = 1; i <= NF; i++) {
    x = $i in BLOCK ? stack_push($i) : stack_pop($i)
    if (x) {
        next
    }
  }
  print print_stack()
  points = 0
  while (0 < STACK_PTR) {
    points *= 5
    points += COST[BLOCK[STACK[STACK_PTR--]]]
  }
  print points
  POINTS[NR] = points
}

END {
    asort(POINTS)
    n = length(POINTS)
    m = int(n/2)
    print n, m, POINTS[m+1]
}

function print_stack(      s, i) {
  for (i = 1; i <= STACK_PTR; i++) s = s STACK[i]
  return s
}

function stack_push(actual,    expected) {
  expected = actual
  STACK[++STACK_PTR] = expected
  return 0
}

function stack_pop(actual,     expected, cost) {
  expected = BLOCK[STACK[STACK_PTR--]]
  return expected != actual
}
