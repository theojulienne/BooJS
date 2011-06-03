l as List = ["foo", "bar", "baz", 0, 1, 2]
print l

for i in l:
	print i

print "THIRD!"
print len(l)

for i in range(l.Count):
	print l[i]

print l.Join("=")

l[1] = "bbb"
print l.IndexOf("bbb")
l.Add("new item")
print l
l.Insert(4, "abc")
print l
l.Remove("bbb")
print l
l.RemoveAt(1)
print l
l += ["newer"]
print l
l.Extend( ["one", "two"] )
print l
print l.Pop( )
print l
