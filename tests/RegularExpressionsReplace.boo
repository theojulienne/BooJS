t1 = "four score and seven years ago"
print t1

t2 = /\w+/.Replace(t1, "X")
print t2

t3 = /\w+/.Replace(t1, "X", 2, 15)
print t3

t3 = /\w+/.Replace(t1, "X", 1, 7)
print t3

t3 = /\w+/.Replace(t1, "X", 0, 15)
print t3

t3 = /\w+/.Replace(t1, "X", 100, 0)
print t3

t4 = /\w+/.Replace(t1) do (m as System.Text.RegularExpressions.Match):
	s = m.ToString()
	if System.Char.IsLower(s[0]):
		return System.Char.ToUpper(s[0]) + s[1:]
	return s
print t4

phonenumber = "5551234567"
phonenumber = /(\d{3})(\d{3})(\d{4})/.Replace(phonenumber, "($1) $2-$3")
print phonenumber
