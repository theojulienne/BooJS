l1 = ["a", "b", "c"]

a1 as (string) = ("one", "two", "three")
#print "for i an a1:"
#for i in a1:
#	print "   print", i

a2 as (int) = array(int, 10)
a2[1] = 3
#print "a2[1]", a2[1]

a3 = array(string, l1)
print "array(string, l1)"
for i in a3: print i

a4 = l1.ToArray(string)
print "l1.ToArray(string)"
for i in a4: print i

a5 = (1, 2) + (3, 4)
print "(1,2)+(3,4)"
for i in a5: print i

if a5 == (1, 2, 3, 4):
	print "good"
else:
	print "bad"
