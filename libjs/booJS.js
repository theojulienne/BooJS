
System = {
	Console: {
		Write: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				str += arguments[i]
				if ( i != arguments.length - 1 ) {
					str += " ";
				}
			}
			support.stdout.write(str);
		},
		WriteLine: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				str += arguments[i];
				if ( i == arguments.length - 1 ) {
					str += "\n";
				} else {
					str += " ";
				}
			}
			support.stdout.write(str);
		}
	},
	Collections: {
		Generic: {
			Dictionary: Class({
				// TODO: Dictionary
			}),
		}
	}
};

Boo = {
	Lang: {
		Runtime: {
			RuntimeServices: {
				op_Match: function( s, pattern ) {
					return s.match(pattern);
				}
			}
		},
		Builtins: {
			print: function( ) {
				var str = "";
				for ( var i = 0; i < arguments.length; i++ ) {
					str += arguments[i];
					if ( i == arguments.length - 1 ) {
						str += "\n";
					} else {
						str += " ";
					}
				}
				support.stdout.write(str);	
			},
			range: function( ) {
				var start, stop, step;
				var result;
				start = 0;
				step = 1;
				if (arguments.length == 1) {
					stop = arguments[0];
				} else if (arguments.length == 2) {
					start = arguments[0];
					stop = arguments[1];
				} else if (arguments.length == 3) {
					start = arguments[0];
					stop = arguments[1];
					step = arguments[2];
				}
				result = [];
				for (i = start; i < stop; i += step) {
					result.push(i);
				}
				return result;
			},
			join: function( array, sep ) {
				return array.join(sep);
			}
		}
	}
}

int = {
	Parse: function( value ) {
		return parseInt( value );
	}
};

double = {
	Parse: function( value ) {
		return parseFloat( value );
	}
};

string = {
	op_Equality: function(a, b) {
		return a == b;
	},
	Compare: function(a, b, ignore_case) {
		if (ignore_case) {
			a = a.toLowerCase();
			b = b.toLowerCase();
		}
		if (a == b) {
			return 0;
		}
		return 1;
	}
};

date = {
	Parse: function( value ) {
		// TODO: Date from string parser.
	}
};

Enumerator = function( array ) {
	this.index = -1;
	this.array = array;
	this.length = array.length;
};

Enumerator.prototype = {
	index: -1,
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

Array.prototype.get_Length = function( ) {
	return this.length;
};

RegExp.prototype.Split = function( string ) {
	return string.split( this );
};

RegExp.prototype.Replace = function( string, newstring ) {
	return string.replace( this, newstring );
};


String.prototype.EndsWith = function( other ) {
	return (other == this.slice( this.length-other.length ));
};

String.prototype.StartsWith = function( other ) {
	return (other == this.slice( 0, other.length ));
};

String.prototype.IndexOf = String.prototype.indexOf;

String.prototype.LastIndexOf = String.prototype.lastIndexOf;

Number.prototype.ToString = Number.prototype.toString;

object = new Class({
	initialize: function ( ) { }
});


// import statements
import = function( name, options ) {
	// TODO: Horribly insecure
	// TODO: Assembly references
	var alias = undefined;
	var assembly_ref = undefined;
	
	if ( options != undefined ) {
		if ( options.from != undefined ) {
			assembly_ref = options.from;
		}
		if ( options.as != undefined ) {
			alias = options.as;
		}
	}

	var namespaceToImport = eval( name );
	if ( alias == undefined ) {
		for ( name in namespaceToImport ) {
			eval( name + " = namespaceToImport['" + name + "'];" );
		}
	} else {
		eval( alias + " = namespaceToImport;" );
	}

};

aliased_import = function( name, assembly_ref ) {
	return eval(name)
};

__initobj__ = function( ) {};
