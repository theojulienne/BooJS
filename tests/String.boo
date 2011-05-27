if "asdf" == "ASDF":
	print "Bad"
else:
	print "Good"

if string.Compare("asdf", "ASDF", true) == 0:
	print "Good"
else:
	print "Bad"

s = "Another String"
if s.StartsWith("Another"):
	print "Good"
else:
	print "Bad"

if s.StartsWith("another"):
	print "Bad"
else:
	print "Good"

if s.EndsWith("String"):
	print "Good"
else:
	print "Bad"

if s.EndsWith("string"):
	print "Bad"
else:
	print "Good"

print s.IndexOf("trin")
print s.LastIndexOf("t")
words = @/ /.Split(s)

for word in words:
	print word

print join(words, "|")
