enum Genre:
	Rock
	Classical
	Pop
	Jazz
	Electronic

enum Suite:
	Spades = 14
	Diamonds = 28
	Clubs = 42
	Hearts = 56

x as Suite
x = Suite.Spades
print(x)
print(cast(int, x))
print(cast(int, Genre.Electronic))
print(cast(int, Genre.Rock))

