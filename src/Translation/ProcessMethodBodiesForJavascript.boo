namespace Translation

import Boo.Lang.Compiler.Steps

# TODO: change local vars made with CreateTempLocal to be a declaration rather than assignment
# (var $1 = 0, rather than $1 = 0)

public class ProcessMethodBodiesForJavascript( ProcessMethodBodiesWithDuckTyping ):
	pass

/*
	public override def LeaveDeclarationStatement( node as DeclarationStatement ):
		pass # avoid processing away declarations, required for "var" insertion
*/	