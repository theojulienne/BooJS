t1 = "four score and seven years ago"
print t1

t2 = /\w+/.Replace(t1, "X")
print t2

t3 = /.o/.Replace(t1, "XX")
print t3
