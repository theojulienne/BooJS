d = {
	"Hello": "World",
	13: 37,
	"Hash": "Table"
}

print d[13]
print d["Hash"]

print

print d["Hello"]
d["Hello"] = 2
print d["Hello"]
d["Hello"] = "World"
print d["Hello"]

print

for i in d:
	print i.Key, "=>", i.Value

print

for i in d.Keys:
	print i, "->", d[i]

print

for i in d.Values:
	print i

print

if d.ContainsKey("Hello"):
	print "good."
else:
	print "bad."

if d.ContainsKey("World"):
	print "bad."
else:
	print "good."

print

if d.ContainsValue("Table"):
	print "good."
else:
	print "bad."

if d.ContainsValue("Hash"):
	print "bad."
else:
	print "good."

print

if d.ContainsKey(13):
	print "good."
else:
	print "bad."

d.Remove(13)

if d.ContainsKey(13):
	print "bad."
else:
	print "good."

print

print d.ToString()

print

hash = Hash( [ ('a', 1), ('b', 2) ] )

for i in hash:
	print i.Key, "=>", i.Value

print

print( (d["badkey"] or "default value") )
print( (d["Hello"] or "default value") )

print

print "first key:", array(d.Keys)[0]
print "first value:", array(d.Values)[0]
