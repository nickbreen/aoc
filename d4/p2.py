import fileinput

count = 0

m = [line.strip() for line in fileinput.input()]

I = len(m)
J = len(m[0])

for i in range(1,I-1):
    for j in range(1, J-1):
        if m[i][j] != "A":
            continue

        # M S
        #  A
        # M S
        if m[i-1][j-1] == "M" and m[i+1][j+1] == "S" and m[i+1][j-1] == "M" and m[i-1][j+1] == "S":
            count += 1

        # M M
        #  A
        # S S
        if m[i-1][j-1] == "M" and m[i+1][j+1] == "S" and m[i-1][j+1] == "M" and m[i+1][j-1] == "S":
            count += 1

        # S M
        #  A
        # S M
        if m[i-1][j-1] == "S" and m[i+1][j+1] == "M" and m[i-1][j+1] == "M" and m[i+1][j-1] == "S":
            count += 1

        # S S
        #  A
        # M M
        if m[i-1][j-1] == "S" and m[i+1][j+1] == "M" and m[i-1][j+1] == "S" and m[i+1][j-1] == "M":
            count += 1



print (count)
