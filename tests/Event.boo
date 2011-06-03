import System

class Sandwich:
	event Eating as EatingEvent
	callable EatingEvent(sammich as object, type as string)

	def Eat():
		Eating(self, "Turkey sammich")

t = Sandwich()
t.Eating += def(obj, sammich):
	print "You're easting a ${sammich}! Yay!"

t.Eating += def(obj, sammich):
	print "Second event."
t.Eat()
