def doByRef(ref x as int):
	x = 4

x = 1
print x
doByRef(x)
print x
