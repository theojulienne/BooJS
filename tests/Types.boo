re = /foo(bar)/

if re isa regex:
	print "re is a regular expression"
else:
	print "re is not a regular expression"

if re isa int:
	print "re is an int"
else:
	print "re is not an int"

if re isa double:
	print "re is an double"
else:
	print "re is not an double"

if re isa object:
	print "re is an object"
else:
	print "re is not an object"

if re isa string:
	print "re is a string"
else:
	print "re is not a string"

s = "12"
if s isa string:
	print "s is a string"
else:
	print "s is not a string"

if s isa regex:
	print "s is a regular expression"
else:
	print "s is not a regular expression"

if s isa int:
	print "s is an int"
else:
	print "s is not an int"

if s isa object:
	print "s is an object"
else:
	print "s is not an object"

