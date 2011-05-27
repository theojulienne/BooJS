var support = {
	stdout: {
		buffer: "",
		write: function( s ) {
			var lines;
			var i;

		    support.stdout.buffer += s;

			lines = support.stdout.buffer.split( '\n' );
			support.stdout.buffer = lines.pop( );

			for ( i = 0; i < lines.length; i++ ) {
				// d8 JS engine
				print( lines[i] );
			}
		},
		flush: function( ) {
			if (support.stdout.buffer.length > 0) {
				write(support.stdout.buffer);
				support.stdout.buffer = "";
			}
		}
	},
}

