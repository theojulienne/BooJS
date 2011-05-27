class Dog ( ):
	Name:
		get:
			return "Canine"
	Legs:
		get:
			print "'Grr... Stop looking at my legs.'"
			return 4

	def Eat(food):
		Speak()

	def Speak():
		print "woof!"

class Rice( ):
	pass

d = Dog()
print d.Name, "has", d.Legs, "legs."
r = Rice()
d.Eat(r)
