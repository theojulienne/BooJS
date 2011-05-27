import Boo.Lang.Compiler
import Boo.Lang.Compiler.IO
import Boo.Lang.Compiler.Ast

import Translation

import System.IO

inputfile = FileInput( argv[0] )

output = StringWriter( )

booc = BooCompiler( )
booc.Parameters.Ducky = false
booc.Parameters.Pipeline = CompileToJavascript( )
booc.Parameters.Input.Add( inputfile )
booc.Parameters.OutputWriter = output

compileContext = booc.Run( )

print "/*"
print compileContext.Errors
print "*/"
print output.ToString( )

