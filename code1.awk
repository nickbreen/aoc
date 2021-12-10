#!/usr/bin/awk --file

BEGIN {
  FPAT = "."
  STACK_PTR = 0
  BLOCK["("] = ")"
  BLOCK["["] = "]"
  BLOCK["{"] = "}"
  BLOCK["<"] = ">"

  COST[")"] = 3
  COST["]"] = 57
  COST["}"] = 1197
  COST[">"] = 25137

  POINTS = 0
}

{
  for (i = 1; i <= NF; i++) {
    x = $i in BLOCK ? stack_push($i) : stack_pop($i)
    #print i, $i, print_stack(), "cost", x
    if (x) {
      POINTS += x
      next
    }
  }
}

END {
  print POINTS
}

function print_stack(      s, i) {
  for (i = 1; i <= STACK_PTR; i++) s = s STACK[i]
  return s
}

function stack_push(actual,    expected) {
  expected = actual
  STACK[++STACK_PTR] = expected
  #print actual, "pushed", expected
  return 0
}

function stack_pop(actual,     expected, cost) {
  expected = BLOCK[STACK[STACK_PTR--]]
  cost = expected == actual ? 0 : COST[actual]
  #print "expected", expected, "actual", actual, "cost", cost
  return cost
}
