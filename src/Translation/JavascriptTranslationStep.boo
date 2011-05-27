namespace Translation

import Boo.Lang.Compiler.Steps
#import Boo.Lang.Compiler.Ast.Visitors

public class JavascriptTranslationStep( AbstractCompilerStep ):
	override def Run( ) as void:
		visitor = JavascriptVisitor( OutputWriter )
		#visitor = BooPrinterVisitor( OutputWriter )
		#visitor = PseudoCSharpPrinterVisitor( OutputWriter )
		#visitor = TreePrinterVisitor( OutputWriter )
		visitor.Print( CompileUnit )
