t = true
f = false

unless f:
	print "Good" unless f
	print "Bad" unless t

unless t:
	print "Bad"

i = 0
if 0 < i and i < 10:
	print i

i = 10
if 0 < i and i < 10:
	print i

i = 9
if 0 < i and i < 10:
	print i

i = 1
if 0 < i and i < 10:
	print i

for i in range(10):
	continue unless i % 2 == 0
	print i

i = 10
while true:
	print i
	i--
	break if i < 5

if true:
	pass

for i in range(3):
	if i == 3:
		print "d"
	elif i == 2:
		print "c"
	elif i == 1:
		print "b"
	else:
		print "a"
