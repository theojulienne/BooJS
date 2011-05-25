System = {
	Console: {
		Write: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				str += arguments[i] + " "
			}
			console.log( str );
		},
		WriteLine: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				str += arguments[i] + " "
			}
			console.log( str );
		}
	}
};

Enumerator = function( array ) {
	this.index = 0;
	this.array = array;
	this.length = array.length;
};

Enumerator.prototype = {
	index: 0,
	length: 0,
	array: null,
	
	MoveNext: function( ) {
		this.index++;
		return this.index < this.length;
	},
	
	get_Current: function( ) {
		return this.array[this.index];
	},
};


// TextReaderEnumerator
Array.prototype.GetEnumerator = function( ) {
	return new Enumerator( this );
};

object = new Class({
	initialize: function ( ) { }
});