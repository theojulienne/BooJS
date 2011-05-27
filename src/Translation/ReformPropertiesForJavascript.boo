namespace Translation

import Boo.Lang.Compiler.Steps

public class ReformPropertiesForJavascript( AbstractNamespaceSensitiveVisitorCompilerStep ):
	def Run( ):
		Visit( CompileUnit )
	
	private def jsPropertyInvoker( definition as string, prefix as string, name as string ) as MethodInvocationExpression:
		initRef  = AstUtil.CreateReferenceExpression( 'this.__' + definition + '__' )
		initExpr = MethodInvocationExpression( initRef.LexicalInfo )
		initExpr.Target = initRef
		initExpr.Arguments.Add( StringLiteralExpression( name ) )
		initExpr.Arguments.Add( AstUtil.CreateReferenceExpression( 'this.' + prefix + '_' + name ) )
		
		return initExpr
	
	def OnProperty( node as Property ):
		if WasVisited( node ):
			return

		MarkVisited( node )
		
		# AstUtil.GetParentClass( node )
		parent as ClassDefinition = node.ParentNode
		
		setter as Method = node.Setter
		getter as Method = node.Getter

		if setter and getter:
			parent.Members.Add( setter )   # add the setter function to the class
			parent.Replace( node, getter ) # replace this node with a getter function
		elif getter:
			parent.Replace( node, getter )
		elif setter:
			parent.Replace( node, setter )
		else:
			print "A property with neither a setter nor a getter?"

		# find a constructor
		constr as Constructor
		for member in parent.Members:
			if member isa Constructor:
				constr = member
				break
		
		# insert at beginning of constructor
		if setter:
			constr.Body.Insert( 0, jsPropertyInvoker( 'defineSetter', 'set', node.Name ) )
		if getter:
			constr.Body.Insert( 0, jsPropertyInvoker( 'defineGetter', 'get', node.Name ) )
