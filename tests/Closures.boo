a = 0
getter = { return a }
setter = { value | a = value }

d as callable
c = do(x as int):
	print x--
	d(x) if x > 0
d = c

print getter()
print a
setter(42)
print getter()
print a
setter(-1)
print getter()
print a

c(10)
