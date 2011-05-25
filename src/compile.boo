import Boo.Lang.Compiler
import Boo.Lang.Compiler.IO
import Boo.Lang.Compiler.Ast

import Translation

import System.IO

inputfile = FileInput( "test.boo" )

output = StringWriter( )

booc = BooCompiler( )
booc.Parameters.Ducky = false
booc.Parameters.Pipeline = CompileToJavascript( )
booc.Parameters.Input.Add( inputfile )
booc.Parameters.OutputWriter = output

compileContext = booc.Run( )

print "Errors: "
print compileContext.Errors


print "Code: "
print output.ToString( )

