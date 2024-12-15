import fileinput

count = 0

m = [line.strip() for line in fileinput.input()]

I = len(m)
J = len(m[0])

for i in range(I):
    for j in range(J):
        print ({"i":i, "j":j, "I":I, "J":J})
        if m[i][j] != "X":
            continue
        if j+3 < J and m[i][j + 1] == "M" and m[i][j + 2] == "A" and m[i][j + 3] == "S":
            count += 1
            print ("found → at %d,%d" % (i, j))
        if 0 <= j-3 and m[i][j - 1] == "M" and m[i][j - 2] == "A" and m[i][j - 3] == "S":
            count += 1
            print ("found ← at %d,%d" % (i, j))
        if i+3 < I and m[i + 1][j] == "M" and m[i + 2][j] == "A" and m[i + 3][j] == "S":
            count += 1
            print ("found ↓ at %d,%d" % (i, j))
        if 0 <= i-3 and m[i - 1][j] == "M" and m[i - 2][j] == "A" and m[i - 3][j] == "S":
            count += 1
            print ("found ↑ at %d,%d" % (i, j))

        if 0 <= i-3 and 0 <= j-3 and m[i - 1][j - 1] == "M" and m[i - 2][j - 2] == "A" and m[i - 3][j - 3] == "S":
            count += 1
            print ("found ↖ at %d,%d" % (i, j))
        if i+3 < I and 0 <= j-3 and m[i + 1][j - 1] == "M" and m[i + 2][j - 2] == "A" and m[i + 3][j - 3] == "S":
            count += 1
            print ("found ↙ at %d,%d" % (i, j))
        if i+3 < I and j+3 < J and m[i + 1][j + 1] == "M" and m[i + 2][j + 2] == "A" and m[i + 3][j + 3] == "S":
            count += 1
            print ("found ↘ at %d,%d" % (i, j))
        if 0 <= i-3 and j+3 < J and m[i - 1][j + 1] == "M" and m[i - 2][j + 2] == "A" and m[i - 3][j + 3] == "S":
            count += 1
            print ("found ↗ at %d,%d" % (i, j))

print (count)
