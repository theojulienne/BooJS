interface IAnimal:
	Name as string:
		get

	Legs as int:
		get

	def Eat( food )

class Dog ( IAnimal ):
	Name:
		get:
			return "Canine"
	Legs:
		get:
			print "'Grr... Stop looking at my legs.'"
			return 4

	def Eat(food):
		if food isa IPlant:
			Speak()

	def Speak():
		print "woof!"

interface IPlant:
	pass

class Rice( IPlant ):
	pass

d = Dog()
print d.Name, "has", d.Legs, "legs."
r = Rice()
d.Eat(r)
