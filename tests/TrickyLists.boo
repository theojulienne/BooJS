myList = [1, 2, 3, "hello", "simple", "kittens"]
if myList.Find( {item | return item == "hello"} ):
	print "good"
else:
	print "bad"

if myList.Find( {i | return (i == "Hello")} ):
	print "bad"
else:
	print "good"
