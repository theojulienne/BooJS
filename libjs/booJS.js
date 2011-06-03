// booJS.js
// David Collien and Dougall Johnson, 2011
// The Boo namespace and runtime tools.

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

// Base class
object = new Class({
	initialize: function ( ) { }
});

// Operators
$boo = {
	// Boo operators
	isa: function( object, typename ) {
		var type = "";
		if (object && object.constructor && object.constructor.toString) {
			var result = object.constructor.toString().match(/function\s*(\w+)/);
			if (result && result.length == 2) {
				type = result[1];
			}
		}
		return (type == typename);
	},
	in_: function( object, iterable ) {
		// TODO
	},
	TypeOf: function( object ) {
		var result;
		var type = "";
		if (object.class_name) {
			return object.class_name;
		} else if (object && object.constructor && object.constructor.toString) {
			var result = object.constructor.toString().match(/function\s*(\w+)/);
			if (result && result.length == 2) {
				type = result[1];
			}
		}
		return type;
	},
	MultipleDispatch: function( functions ) {
		var Dispatcher = function( ) {
			var i;
			types = "";
			for ( i = 0; i < arguments.length; i++ ) {
				if (i != 0) {
					types += ", ";
				}
				types += $boo.TypeOf(arguments[i]);
			}

			if (functions[types]) {
				return functions[types].apply(this, arguments);
			} else if (functions["default"]) {
				return functions["default"].apply(this, arguments);
			} else {
				throw "No handler found for: <" + types + "> - add or add a default handler";
			}
		}
		return Dispatcher;
	},

	// Boo literals
	timespan: function( literal ) {
		var ts;

		ts = new System.TimeSpan( );
		return ts;
	},
	hash: function( items ) {
		return new Boo.Lang.Hash( items );
	},
	array: function( items ) {
		return new $boo.BooArray( items );
	},
	list: function( items ) {
		return new Boo.Lang.List( items );
	},
	regex: function( regex, options ) {
		return eval( "/" + regex + "/g" + options );
	},
	BooArray: new Class({
		class_name: "BooArray",
		Implements: Array,
		initialize: function( values ) {
			var i;
		
			for ( i = 0; i < values.length; i++ ) {
				this.push( values[i] );
			}
		},
		ToString: function( ) {
			return "BooArray";
		},
		GetEnumerator: function( ) {
			return new Enumerator( this );
		},
		get_Length: function( ) {
			return this.length;
		}
	})
}

// import statement
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


// Placeholders
__initobj__ = function( ) { };
__addressof__ = function( x ) { return x; };


// .NET "System"
System = {
	Console: {
		Write: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				if ( arguments[i].ToString ) {
					str += arguments[i].ToString( );
				} else {
					str += $boo.TypeOf( arguments[i] );
				}
				if ( i != arguments.length - 1 ) {
					str += " ";
				}
			}
			support.stdout.write(str);
		},
		WriteLine: function( ) {
			var str = "";
			for ( var i = 0; i < arguments.length; i++ ) {
				if ( arguments[i].ToString ) {
					str += arguments[i].ToString( );
				} else {
					str += $boo.TypeOf( arguments[i] );
				}
				if ( i < arguments.length - 1 ) {
					str += " ";
				}
			}
			str += "\n";
			support.stdout.write(str);
		}
	},
	Collections: {
		Generic: {
			Dictionary: new Class({
				// TODO
			}),
			IEnumerable: {
				// TODO
			}
		}
	},
	Predicate: new Class({
		// TODO
	}),
	Text: {
		RegularExpressions: {
			Regex: {
				// TODO???
			}
		}
	},
	Int32: {
		Parse: function( value ) {
			return parseInt( value );
		}
	},
	Double: {
		Parse: function( value ) {
			return parseFloat( value );
		}
	},
	TimeSpan: {
		op_Addition: function( a, b ) {
			// TODO
		},
		op_Subtraction: function( a, b ) {
			// TODO
		}
	},
	DateTime: {
		Parse: function( s ) {
			// TODO
		}
	},
	String: {
		op_Equality: function( a, b ) {
			return (a == b);
		},
		Compare: function( a, b, ignore_case ) {
			if ( ignore_case ) {
				a = a.toLowerCase();
				b = b.toLowerCase();
			}
			if ( a == b ) {
				return 0;
			}
			return 1;
		}
	},
	Type: {
		// TODO
	},
	MonoType: {
		// TODO
	}
};


// Boo.*
Boo = {
	Lang: {
		Runtime: {
			RuntimeServices: {
				op_Match: function( s, pattern ) {
					return s.match(pattern);
				},
				op_Equality: function( array1, array2 ) {
					var i;

					if (array1.length != array2.length)
						return false;

					for (i = 0; i < array1.length; i++) {
						if (array1[i] != array2[i]) {
							return false;
						}
					}

					return true;
				},
				AddArrays: function( type, array1, array2 ) {
					var i;
					var l;

					l = array1.slice(0);
					for ( i = 0; i < array2.length; i++ ) {
						l.push( array2[i] );
					}

					return new $boo.BooArray( l );
				}
			}
		},
		Builtins: {
			print: function( ) {
				var str = "";
				for ( var i = 0; i < arguments.length; i++ ) {
					str += arguments[i].ToString();
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
				if ( arguments.length == 1 ) {
					stop = arguments[0];
				} else if ( arguments.length == 2 ) {
					start = arguments[0];
					stop = arguments[1];
				} else if ( arguments.length == 3 ) {
					start = arguments[0];
					stop = arguments[1];
					step = arguments[2];
				}

				result = [];
				for ( i = start; i < stop; i += step ) {
					result.push( i );
				}

				return $boo.list( result );
			},
			join: function( array, sep ) {
				return array.join(sep);
			},
			array: $boo.MultipleDispatch({
				"Object, Number": function( type, size ) {
					var l;
					var i;

					l = [];
					for ( var i = 0; i < size; i++ ) {
						l.push( undefined );
					}
					return new $boo.BooArray( l );
				},
				"Object, Boo.Lang.List": function( type, items ) {
					return new $boo.BooArray( items.values );
				}
			})
			
		},

		List: new Class({
			class_name: "Boo.Lang.List",
			initialize: function( values ) {
				this.values = values;
			},
			ToString: function( ) {
				return "[" + this.values.join( ", " ) + "]";
			},
			ToArray: function( ) {
				return new $boo.BooArray( this.values );
			},
			GetEnumerator: function( ) {
				return new Enumerator( this.values );
			},
			Join: function( sep ) {
				return this.values.join( sep );
			},
			IndexOf: function( value ) {
				return this.values.indexOf( value );
			},
			Add: function( value ) {
				this.values.push( value );
			},
			Insert: function( i, value ) {
				this.values.splice( i, 0, value );
			},
			Extend: function( list ) {
				this.values = this.values.concat( list.values );
			},
			Pop: function( value ) {
				return this.values.pop( );
			},
			Remove: function( value ) {
				this.RemoveAt( this.IndexOf( value ) );
			},
			RemoveAt: function( i ) {
				this.values.splice(i, 1);
			},
			get_Count: function( ) {
				return this.values.length;
			},
			get_Item: function( i ) {
				return this.values[i];
			},
			set_Item: function( i, value ) {
				return (this.values[i] = value);
			},

			// static
			statics: {
				op_Addition: function( a, b ) {
					return new Boo.Lang.List( a.values.concat( b.values ) );
				}
			}
		}),

		Hash: new Class({
			class_name: "Boo.Lang.Hash",
			initialize: function( values ) {
				var i;
				if ( $boo.isa(values, "Object") ) {
					this.values = values;
				} else if ( $boo.isa(values, "Array") ) {
					this.values = {};
					for (i = 0; i < values.length; i++) {
						this.values[values[i][0]] = values[i][1];
					}
				} else {
					this.values = {};
				}
			},
			ContainsKey: function( key ) {
				var i;

				for ( i in this.values ) {
					if ( i == key ) {
						return true;
					}
				}
				return false;
			},
			ContainsValue: function( key ) {
				var i;

				for ( i in this.values ) {
					if ( this.values[i] == key ) {
						return true;
					}
				}
				return false;
			},
			Remove: function( key ) {
				delete this.values[key];
			},
			set_Item: function( key, value ) {
				return (this.values[key] = value);
			},
			get_Item: function( key ) {
				return this.values[key];
			},
			get_Keys: function( ) {
				var i;
				var l;

				l = [];
				for ( i in this.values ) {
					l.push(i);
				}
				return l;
			},
			get_Values: function( ) {
				var i;
				var l;

				l = [];
				for ( i in this.values ) {
					l.push(this.values[i]);
				}
				return l;
			},
			GetEnumerator: function( ) {
				var KeyValue = new Class({
					initialize: function(k, v) {
						this.k = k;
						this.v = v;
					},
					get_Key: function() {
						return this.k;
					},
					get_Value: function() {
						return this.v;
					}
				});
				l = [];
				for ( i in this.values ) {
					l.push( new KeyValue( i, this.values[i] ) );
				}
				return new Enumerator( l );
			}
		})
	}
}



RegExp.prototype.Split = function( string ) {
	return $boo.array( string.split( this ) );
};

RegExp.prototype.Replace = function( string, newstring ) {
	return string.replace( this, newstring );
};

RegExp.prototype.ToString = function( ) {
	var s = this.toString();
	return s.slice(1, s.lastIndexOf("/"));
}

String.prototype.EndsWith = function( other ) {
	return (other == this.slice( this.length-other.length ));
};

String.prototype.StartsWith = function( other ) {
	return (other == this.slice( 0, other.length ));
};

String.prototype.ToString = function( ) {
	return this;
}

String.prototype.IndexOf = String.prototype.indexOf;

String.prototype.LastIndexOf = String.prototype.lastIndexOf;

Number.prototype.ToString = Number.prototype.toString;

// Import
import( "Boo.Lang.Hash", {as: "Hash"} )
import( "System.TimeSpan", {as: "timespan"} )
import( "System.DateTime", {as: "date"} )
import( "System.Int32", {as: "int"} )
import( "System.Double", {as: "double"} )
import( "System.String", {as: "string"} )
import( "System.Text.RegularExpressions.Regex", {as: "regex"} )
