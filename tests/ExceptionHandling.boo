class MyExceptionA(System.Exception):
	def constructor():
		super("Exception A")

class MyExceptionB(System.Exception):
	def constructor():
		super("Exception B")

def f(x as int):
	if x > 10:
		raise MyExceptionA()
	elif x < -10:
		raise MyExceptionB()
	elif x == -5:
		raise "Not negative five, dammit!"
	else:
		return 15/x

for i in range(-15,16,5):
	System.Console.Write("f("+i+"): ")
	try:
		print f(i)
	except e as MyExceptionA:
		print "Caught the first one."
	except e as MyExceptionB:
		print "Caught the second one.", e.Message
	except e as System.DivideByZeroException:
		print "Division by zero kills."
	except e:
		print "What's this one?", e.Message
	ensure:
		print "(ensured)"
