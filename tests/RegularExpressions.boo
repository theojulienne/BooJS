s = """
Joe Jackson
131 W. 5th Street
New York, NY  10023
"""

r = /(?<=\n)\s*(?<city>[^\n]+)\s*,\s*(?<state>\w+)\s+(?<zip>\d{5}(-d{4})?).*$/.Match(s)

print r.Groups["city"]
print r.Groups["state"]
print r.Groups["zip"]

samplestring = "Here is foo"

if samplestring =~ /foo/:
	print "Matches."
else:
	print "Doesn't match."

if samplestring =~ /Foo/:
	print "Matches."
else:
	print "Doesn't match."

if samplestring =~ "foo":
	print "Matches."
else:
	print "Doesn't match."

if samplestring =~ "Foo":
	print "Matches."
else:
	print "Doesn't match."

if samplestring !~ "Foo":
	print "Doesn't match."
else:
	print "Matches."

p = /(?i)google/
print "google" =~ p
print "Google" =~ p

