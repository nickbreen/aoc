import fileinput

import sys
from click import prompt

up = "^"
down = "v"
left = "<"
right = ">"
dirs = [up, down, left, right]
next_dir = {up: right, right: down, down: left, left: up}
prev_dir = {a:b for b,a in next_dir.items()}
empty = "."
obstacle = "#"
patrolled = "X"

print (sys.argv[1:])

map = [list(line.strip()) for line in fileinput.input(files=sys.argv[1:])]

guard = (0,0, None)
for y in range(len(map)):
    for x in range(len(map[y])):
        if map[y][x] in dirs:
            guard = (y,x,map[y][x])
            break

route = []
obstacles = []
try:
    while True: #prompt("Press Enter to continue...", True):
        #print (f"guard is at {guard}")

        # Wrong, needs to check that an obstacle is anywhere to the next_dir of the guard
        if (guard[0], guard[1], next_dir[guard[2]]) in route:
            obstacles += [(guard[0], guard[1], next_dir[guard[2]])]
        route += [guard]
        map[guard[0]][guard[1]] = patrolled
        if guard[2] == up and map[guard[0]-1][guard[1]] != obstacle:
            guard = (guard[0]-1, guard[1], guard[2])
        elif guard[2] == down and map[guard[0]+1][guard[1]] != obstacle:
            guard = (guard[0]+1, guard[1], guard[2])
        elif guard[2] == left and map[guard[0]][guard[1]-1] != obstacle:
            guard = (guard[0], guard[1]-1, guard[2])
        elif guard[2] == right and map[guard[0]][guard[1]+1] != obstacle:
            guard = (guard[0], guard[1]+1, guard[2])
        else:
            guard = (guard[0], guard[1], next_dir[guard[2]])
        map[guard[0]][guard[1]] = guard[2]

       #print ("\n".join(["".join(line) for line in map]))

except IndexError:
    #print ("\n".join(["".join(line) for line in map]))
    n = sum([1 for line in map for c in line if c == patrolled])
    print (f"guard exited at {guard} after patrolling {n} squares with {len(obstacles)} new loop obstacles: \n{obstacles}\n over route: \n{route}")
    exit(0)
