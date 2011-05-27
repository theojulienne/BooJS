class Rectangle ( object ):
	width as double
	height as double

	def constructor( width as double, height as double ):
		self.width = width
		self.height = height
	
	def area( ):
		return width * height

print Rectangle( 2, 3.0 ).area( )

