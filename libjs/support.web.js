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
				// web JS console
				console.log( lines[i] );
			}
		},
		flush: function( ) {

			console.log(support.stdout.buffer);
			support.stdout.buffer = "";
		}
	},
}

