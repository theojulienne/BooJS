s = "Lorem ipsum, dolor sit\tamet!"

words = @/ /.Split(s)

for word in words:
	print word

print join(words, "|")
