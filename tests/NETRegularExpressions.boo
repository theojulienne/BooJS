import System.Text.RegularExpressions

s1 = "Here is foo"
s2 = "Here is bar"
re = Regex( "FOO", RegexOptions.IgnoreCase | RegexOptions.Compiled )

if s1 =~ re:
	print "matched"
else:
	print "no match"

if s2 =~ re:
	print "matched"
else:
	print "no match"

if re.IsMatch(s1):
	print "matched"
else:
	print "no match"

if re.IsMatch(s2):
	print "matched"
else:
	print "no match"
