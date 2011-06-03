l = ["a", "b", "c"]
for i, j in enumerate(l):
	print i, j

print join(l)
print join(l, "|")

def addX(i):
	return i + "XXX"

for i in map(l, addX):
	print i

foo = matrix(int, 2, 2)
foo[0, 0] = 0
foo[0, 1] = 1
foo[1, 0] = 2
foo[1, 1] = 3
print join(" ", foo)

print zip(["a", "b", "c"], ["x", "y", "z"])
