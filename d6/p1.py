import fileinput

import sys
from click import prompt

up = "^"
down = "v"
left = "<"
right = ">"
dirs = [up, down, left, right]
next_dir = {up: right, right: down, down: left, left: up}
empty = "."
obstacle = "#"
patrolled = "X"

map = [list(line.strip()) for line in fileinput.input(files=sys.argv)]

guard = (0,0, None)
for y in range(len(map)):
    for x in range(len(map[y])):
        if map[y][x] in dirs:
            guard = (y,x,map[y][x])
            break

#print ("\n".join(["".join(line) for line in map]))

try:
    while True: #prompt("Press Enter to continue...", True):
        print (f"guard is at {guard}")
        map[guard[0]][guard[1]] = patrolled
        if guard[2] == up and map[guard[0]-1][guard[1]] != obstacle:
            guard = (guard[0]-1, guard[1], guard[2])
        elif guard[2] == up:
            guard = (guard[0], guard[1], next_dir[guard[2]])
        elif guard[2] == down and map[guard[0]+1][guard[1]] != obstacle:
            guard = (guard[0]+1, guard[1], guard[2])
        elif guard[2] == down:
            guard = (guard[0], guard[1], next_dir[guard[2]])
        elif guard[2] == left and map[guard[0]][guard[1]-1] != obstacle:
            guard = (guard[0], guard[1]-1, guard[2])
        elif guard[2] == left:
            guard = (guard[0], guard[1], next_dir[guard[2]])
        elif guard[2] == right and map[guard[0]][guard[1]+1] != obstacle:
            guard = (guard[0], guard[1]+1, guard[2])
        elif guard[2] == right:
            guard = (guard[0], guard[1], next_dir[guard[2]])
        map[guard[0]][guard[1]] = guard[2]
       #print ("\n".join(["".join(line) for line in map]))

except IndexError:
    #print ("\n".join(["".join(line) for line in map]))
    route = [1 for line in map for c in line if c == patrolled]
    n = sum(route)
    print (f"guard exited at {guard} after patrolling {n-1} squares")
    exit(0)
