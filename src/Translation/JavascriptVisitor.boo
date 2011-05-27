namespace Translation

import System
import System.IO

import Boo.Lang.Compiler.Ast.Visitors
import Boo.Lang.Compiler.TypeSystem

public class JavascriptVisitor( BooPrinterVisitor ):
	private eNum as int = 0
	
	def constructor( writer as TextWriter ):
		super( writer )
	
	new def Print( ast as CompileUnit ):
		OnCompileUnit( ast )
		
	def WriteKeyword( text as string ):
		Write( text )
		
	def WriteOperator( text as string ):
		Write( text )
	

	## Imports
	def OnImport( node as Import ):
		Write( 'import(' )
		WriteStringLiteral( node.Namespace )

		if node.AssemblyReference != null or node.Alias != null:
			Write( ", {" )

			if node.AssemblyReference != null:
				Write("from: ")
				WriteStringLiteral( node.AssemblyReference.Name )

			if node.Alias != null:
				if node.AssemblyReference != null:
					Write( ", " )

				Write( 'as: "' )
				Visit( node.Alias )
				Write( '"' )

			Write("}")

		WriteLine( ');' )
	
	## Statements
	def OnExpressionStatement( node as ExpressionStatement ):
		WriteIndented( )
		Visit( node.Expression )
		Visit( node.Modifier )
		Write( ";" )
		WriteLine( )
	
	def OnDeclarationStatement( d as DeclarationStatement ):
		WriteIndented( )
		Visit( d.Declaration )
		if d.Initializer != null:
			WriteOperator( " = " )
			Visit( d.Initializer )
		Write( ";" )
		WriteLine( )
			
	def OnUnpackStatement( us as UnpackStatement ):
		WriteIndented( )
		Write( "let [" )
		for i in range ( us.Declarations.Count ):
			if i > 0:
				Write(", ");
				
			Visit( us.Declarations[i] )
		Write( "]" )
		WriteOperator( " = " )
		Visit( us.Expression )
		Visit( us.Modifier )
		Write( ";" )
		WriteLine( )
		
	def OnDeclaration( d as Declaration ):
		# Write( "var " )
		Write( d.Name )
		# WriteTypeReference( d.Type )
	
	def OnReturnStatement( r as ReturnStatement ):
		WriteIndented( )
		WriteKeyword( "return" )
		if r.Expression != null or r.Modifier != null:
			Write(" ")
		Visit( r.Expression )
		Visit( r.Modifier ) # TODO
		Write( ";" )
		WriteLine( )
		
		
	## Module
	
	def OnModule( module as Module ):
		Visit( module.Namespace )
		
		if module.Imports.Count > 0:
			Visit( module.Imports )
			WriteLine( )
		
		for member in module.Members:
			Visit( member )
			WriteLine( )
			
		if module.Globals != null:
			Visit( module.Globals.Statements )
		
		for attribute in module.Attributes:
			pass # attributes not supported
			
		for attribute in module.AssemblyAttributes:
			pass # attributes not supported
	
	
	## Class Stuff
	
	def OnClassDefinition( classDef as ClassDefinition ):
		Write( "var " + classDef.Name + " = new Class({" )
		WriteLine( )
		Indent( )
		
		
		# inheritance
		if classDef.BaseTypes.Count > 0:
			for baseType in classDef.BaseTypes:
				WriteIndented( )
				Write( "Extends: " )
				Visit( baseType )
				Write( ", " )
				WriteLine( )
				break
		
		i = 0
		numMembers = classDef.Members.Count
		# class contents
		if numMembers > 0:
			for member in classDef.Members:
				Visit( member )
				if i != numMembers-1:
					Write( "," )
				WriteLine( )
				++i
		
		Dedent( )
		Write( "});" )
		WriteLine( )
	
	def OnConstructor( constructorDef as Constructor ):
		name = constructorDef.Name
		constructorDef.Name = "initialize"
		OnMethod( constructorDef ) # TODO
		constructorDef.Name = name

	def OnDestructor( destructorDef as Destructor ):
		OnMethod( destructorDef )
	
	def OnMethod( method as Method ):
		WriteLine( )
		if method.IsRuntime:
			pass #WriteImplementationComment( "runtime" )
		
		WriteIndented( )
		WriteCallableDefinitionHeader( method )
		
		BeginBlock( )
		
		nameUsed = {}
		for local in method.Locals:
			if not nameUsed[local.Name]:
				Visit( local )
				nameUsed[local.Name] = true
			else:
				WriteIndented( "// duplicate local: " + local.Entity.ToString( ) )
				WriteLine( )
			
		WriteLine( )
		Visit( method.Body )
		EndBlock( )	
	
	def OnRELiteralExpression( node as RELiteralExpression ):
		Write( "/" )
		Write( node.Pattern )
		Write( "/g" )

	def OnArrayLiteralExpression( node as ArrayLiteralExpression ):
		Write("[");
		i = 0
		numItems = node.Items.Count
		
		if numItems != 0:
			for item in node.Items:
				if i != 0:
					Write(", ")
				Visit( item )
				i++
		Write("]")

	def OnSelfLiteralExpression( node as SelfLiteralExpression ):
		WriteKeyword( "this" )
		
	def OnSuperLiteralExpression( node as SuperLiteralExpression ):
		WriteKeyword( "this.parent" )
		
	def OnField( f as Field ):
		WriteIndented( )
		# WriteAttributes(f.Attributes, true)
		# WriteModifiers(f)
		Write( f.Name )
		# WriteTypeReference( f.Type )
		
		WriteOperator( ": " )
		
		if f.Initializer != null:
			Visit( f.Initializer )
		else:
			Write( "null" )
		
	
	def OnProperty( node as Property ):
		pass
		# properties are ignored as they should have already been transformed
		# into methods
		# raise NotImplementedException( "Not Implemented: " + node.ToString( ) ) 
	
	
	def OnTryCastExpression( e as TryCastExpression ):
		Visit( e.Target )
		// raise NotImplementedException( "Not Implemented: " + e.ToString( ) )
		
		
	def OnCastExpression( node as CastExpression ):
		Visit( node.Target )
		// raise NotImplementedException( "Not Implemented: " + node.ToString( ) )
		
	def WriteUnimplementedBlock( comment as String, block as Block ):
		WriteIndented( )
		Write( "/* " + comment + ": " )
		WriteLine( )
		Indent( )
		
		WriteBlockStatements( block )
		
		Dedent( )
		WriteIndented( )
		Write ( "*/" )
		WriteLine( )
	
	
	def OnLocal( node as Local ):
		WriteIndented( )
		Write( "// {0} {1}", node.Entity, ("private" if node.PrivateScope else "") )
		WriteLine( )
		WriteIndented( )
		Write( "var " + node.Name + ";" )
		WriteLine( )
	
	def OnTryStatement( node as TryStatement ):
		# TODO: at the moment this just outputs the protected block
		
		WriteIndented( )
		Write( "// try/catch Block not Implemented: " )
		WriteLine( )
		
		# WriteKeyword( "try" )
		
		WriteBlockStatements( node.ProtectedBlock )
		# TODO
		
		if node.EnsureBlock != null:
			WriteUnimplementedBlock( "ensure", node.EnsureBlock )

		if node.FailureBlock != null:
			WriteUnimplementedBlock( "failure", node.FailureBlock )

		if node.ExceptionHandlers.Count > 0:
			WriteIndented( )
			Write( "/* exception handlers: " )
			WriteLine( )
			Indent( )
			
			Visit( node.ExceptionHandlers )
			WriteLine( )
			
			Dedent( )
			WriteIndented( )
			Write( "*/" )
			WriteLine( )
		
		/*
		eNum++
		WriteKeyword( " catch ( \$e" + eNum.ToString( ) + " )" )
		
		BeginBlock( )
		Visit( node.ExceptionHandlers )
		# TODO
		# WriteBlock( node.FailureBlock )
		
		WriteLine( )
		EndBlock( )
		
		eNum--
		*/
		
		WriteIndented( )
		Write( "// End try/catch Block" )
		WriteLine( )
		
		
	def OnExceptionHandler( node as ExceptionHandler ):
		WriteIndented( )
		Write( "catch ( " )
		if (node.Flags & ExceptionHandlerFlags.Untyped) == ExceptionHandlerFlags.None:
			if (node.Flags & ExceptionHandlerFlags.Anonymous) == ExceptionHandlerFlags.None:
				Visit( node.Declaration )
			else: 
				raise NotImplementedException( "Not Implemented: " + node.Declaration.Type.ToString( ) )
				# WriteTypeReference( node.Declaration.Type )
			
		elif (node.Flags & ExceptionHandlerFlags.Anonymous) == ExceptionHandlerFlags.None:
			Write( " " )
			Write( node.Declaration.Name )
		
		Write( " )" )
		
		if (node.Flags & ExceptionHandlerFlags.Filter) == ExceptionHandlerFlags.Filter:
			raise NotImplementedException( "Not Implemented: " + node.FilterCondition.ToString( ) )
			/*	
			unless as UnaryExpression = node.FilterCondition as UnaryExpression
			if unless != null and unless.Operator == UnaryOperatorType.LogicalNot:
			
				WriteKeyword( " unless " )
				Visit( unless.Operand )
			else:
				WriteKeyword( " if " )
				Visit( node.FilterCondition )					
			*/
		
		WriteBlock( node.Block )
		
	## Block Stuff

	new def WriteParameterList( items as ParameterDeclarationCollection, start as string, end as string ):
		Write( start )
		
		i = 0
		for item in items:
			if i > 0:
				Write( ", " )
				
			if item.IsParamArray:
				raise NotImplementedException( "Not Implemented: " + item.ToString( ) )
				# Write( "*" ) # TODO
			
			Visit( item )
			++i
		Write( end )
	
	new def WriteModifiers( member as TypeMember ):
		pass
		
	new def WriteBlock( b as Block ):
		BeginBlock( )
		WriteBlockStatements( b )
		EndBlock( )
	
	def CompleteBlock( b as Block ):
		WriteBlockStatements( b )
		EndBlock( )
	
	new def BeginBlock( ):
		Write( " { " )
		WriteLine( )
		Indent( )
		
	new def EndBlock( ):
		Dedent( )
		WriteIndented( )
		Write( "}" )
		
	new def WriteBlockStatements( b as Block ):
		if not b.IsEmpty:
			Visit( b.Statements )
	
	new def IsCallableTypeReferenceParameter( p as ParameterDeclaration ):
		parentNode = p.ParentNode
		return parentNode != null and parentNode.NodeType == NodeType.CallableTypeReference
		
	def OnParameterDeclaration( p as ParameterDeclaration ):
		Write( p.Name )

	new def WriteConditionalBlock( keyword as string, condition as Expression, block as Block ):
		WriteIndented( )
		WriteKeyword( keyword + " ( " )
		Visit( condition )
		Write( " )" )
		WriteBlock( block )
		WriteLine( )
	
	new def WriteCallableDefinitionHeader( node as CallableDefinition ):
		Write( node.Name )
		Write( ": function" )
		WriteParameterList( node.Parameters, "( ", " )" );

		
	## While, If Stuff
		
	def OnWhileStatement( node as WhileStatement ):
		WriteConditionalBlock( "while", node.Condition, node.Block )
		
		if node.OrBlock != null:
			raise NotImplementedException( "Not Implemented: " + node.OrBlock.ToString( ) )
			// TODO
			/*
			WriteIndented( )
			WriteKeyword( "or:" )
			WriteLine( )
			WriteBlock( node.OrBlock )
			*/
			
		if node.ThenBlock != null:
			// TODO
			raise NotImplementedException( "Not Implemented: " + node.ThenBlock.ToString( ) )
			/*
			WriteIndented( )
			WriteKeyword( "then:" )
			WriteLine( )
			WriteBlock( node.ThenBlock )
			*/
		
	def OnConditionalExpression( e as ConditionalExpression ):
		# (a if condition else b)
		# (condition?a:b)
		Write( "(" )
		Visit( e.Condition )
		Write( "?" )
		Visit( e.TrueValue )
		Write( ":" )
		Visit( e.FalseValue )
		Write( ")" )

	def OnIfStatement( node as IfStatement ):
		WriteIfBlock( "if", node )
		
		elseBlock as Block = WriteElifs( node )
		if elseBlock != null:
			WriteKeyword( " else" )
			WriteBlock( elseBlock )
			
		WriteLine( )
		
	new def WriteIfBlock( keyword as string, ifs as IfStatement ):
		WriteIndented( )
		WriteKeyword( keyword )
		Write( " ( " )
		Visit( ifs.Condition )
		Write( " )" )
		WriteBlock( ifs.TrueBlock )
	
	new def WriteElifs( node as IfStatement ) as Block:
		falseBlock as Block = node.FalseBlock
		while IsElif( falseBlock ):
			stmt as IfStatement = falseBlock.Statements[0]
			WriteIfBlock(" else if", stmt)
			falseBlock = stmt.FalseBlock
		return falseBlock
		
	new def IsElif( block as Block ) as bool:
		if block == null:
			return false
		
		if block.Statements.Count != 1:
			return false
		
		return block.Statements[0] isa IfStatement

	def OnForStatement( fs as ForStatement ):
		WriteIndented( )
		
		Write( "for ( var __boojs_pair in Iterator( " )
		Visit( fs.Iterator )
		Write( " ) " )
		
		Write( " )" )
		
		BeginBlock( )
		WriteIndented( )
		
		Write( "var " );
		
		if fs.Declarations.Count > 1:
			raise NotImplementedException( "Not Implemented: " + fs.ToString( ) )
			
		for i in range( fs.Declarations.Count ):
			if i > 0:
				Write(", ")
			Visit( fs.Declarations[i] )
		
		Write( " = __boojs_pair[1];" )
		WriteLine( )
		
		CompleteBlock( fs.Block )
		
		WriteLine( )
		
		if fs.OrBlock != null:
			raise NotImplementedException( "Not Implemented: " + fs.OrBlock.ToString( ) )
			/*
			WriteIndented( )
			WriteKeyword( " or: ")
			WriteLine( )
			WriteBlock( fs.OrBlock )
			*/
		
		if fs.ThenBlock != null:
			raise NotImplementedException( "Not Implemented: " + fs.ThenBlock.ToString( ) )
			/*
			WriteIndented( )
			WriteKeyword( "then:" )
			WriteLine( )
			WriteBlock( fs.ThenBlock )
			*/
		
	## Expressions
	
	def OnReferenceExpression( node as ReferenceExpression ):
		if node.Entity isa IConstructor:
			Write( "new " )
		
		Write( node.Name )
		
	def OnMethodInvocationExpression( e as MethodInvocationExpression ):
		Visit( e.Target )
		Write( "( " )
		WriteCommaSeparatedList( e.Arguments )
		if e.NamedArguments.Count > 0:
			if e.Arguments.Count > 0:
				Write( ", " )
			WriteCommaSeparatedList( e.NamedArguments )
			
		Write( " )" )
	
	new def NeedParensAround( e as Expression ) as bool:
		if e.ParentNode == null:
			return false
			
		if e.ParentNode.NodeType == NodeType.ExpressionStatement or e.ParentNode.NodeType == NodeType.MacroStatement or e.ParentNode.NodeType == NodeType.IfStatement or e.ParentNode.NodeType == NodeType.WhileStatement or e.ParentNode.NodeType == NodeType.UnlessStatement:
				return false
		
		return true
	
	def OnBinaryExpression( e as BinaryExpression ):
		needsParens as bool = NeedParensAround( e )
		if needsParens:
			Write( "(" )
			
		Visit( e.Left )
		Write( " " )
		WriteOperator( GetBinaryOperatorText( e.Operator ) )
		Write( " " )
		if ( e.Operator == BinaryOperatorType.TypeTest ):
			// isa rhs is encoded in a typeof expression
			Visit( ( e.Right cast TypeofExpression ).Type )
		else:
			Visit( e.Right )
		
		if needsParens:
			Write( ")" )
			
	def OnUnaryExpression( node as UnaryExpression ):
		addParens as bool = NeedParensAround( node ) and not IsMethodInvocationArg( node )
		if addParens:
			Write( "(" )
			
		postOperator as bool = AstUtil.IsPostUnaryOperator( node.Operator )
		if not postOperator:
			WriteOperator( GetUnaryOperatorText( node.Operator ) )
		
		Visit( node.Operand )
		
		if postOperator:
			WriteOperator( GetUnaryOperatorText( node.Operator ) )
			
		if addParens:
			Write( ")" )
			
	new def IsMethodInvocationArg( node as UnaryExpression ) as bool:
		parent as MethodInvocationExpression = node.ParentNode
		return null != parent and node != parent.Target
		
	## Operators
	
	static def GetUnaryOperatorText( op as UnaryOperatorType ) as string:
		if op == UnaryOperatorType.Explode:
				return "*"
		elif op == UnaryOperatorType.PostIncrement or UnaryOperatorType.Increment:
				return "++"
		elif op == UnaryOperatorType.PostDecrement or UnaryOperatorType.Decrement:
				return "--"
		elif op == UnaryOperatorType.UnaryNegation:
				return "-"
		elif op == UnaryOperatorType.LogicalNot:
				return "! "
		elif op == UnaryOperatorType.OnesComplement:
				return "~"
		elif op == UnaryOperatorType.AddressOf:
				return "&"
		elif op == UnaryOperatorType.Indirection:
				return "*"
		
		raise ArgumentException( "op" )

	static def GetBinaryOperatorText( op as BinaryOperatorType ) as string:
		/*
		operators = {
			BinaryOperatorType.Assign:     "=",
			BinaryOperatorType.Equality:   "==",
			BinaryOperatorType.Inequality: "!=",
			BinaryOperatorType.Addition:   "+",
			BinaryOperatorType.InPlaceAddition
			...
		}
		*/
		
		if op == BinaryOperatorType.Assign:
				return "="
		elif op == BinaryOperatorType.Equality:
				return "=="
		elif op == BinaryOperatorType.Inequality:
				return "!="
		elif op == BinaryOperatorType.Addition:
				return "+"
		elif op == BinaryOperatorType.InPlaceAddition:
				return "+="
		elif op == BinaryOperatorType.InPlaceBitwiseAnd:
				return "&="
		elif op == BinaryOperatorType.InPlaceBitwiseOr:
				return "|="
		elif op == BinaryOperatorType.InPlaceSubtraction:
				return "-="
		elif op == BinaryOperatorType.InPlaceMultiply:
				return "*="
		elif op == BinaryOperatorType.InPlaceModulus:
				return "%="
		elif op == BinaryOperatorType.InPlaceExclusiveOr:
				return "^="
		elif op == BinaryOperatorType.InPlaceDivision:
				return "/="
		elif op == BinaryOperatorType.Subtraction:
				return "-"
		elif op == BinaryOperatorType.Multiply:
				return "*"
		elif op == BinaryOperatorType.Division:
				return "/"
		elif op == BinaryOperatorType.GreaterThan:
				return ">"
		elif op == BinaryOperatorType.GreaterThanOrEqual:
				return ">="
		elif op == BinaryOperatorType.LessThan:
				return "<"
		elif op == BinaryOperatorType.LessThanOrEqual:
				return "<="
		elif op == BinaryOperatorType.Modulus:
				return "%"
		elif op == BinaryOperatorType.Or:
				return "||"
		elif op == BinaryOperatorType.And:
				return "&&"
		elif op == BinaryOperatorType.BitwiseOr:
				return "|"
		elif op == BinaryOperatorType.BitwiseAnd:
				return "&"
		elif op == BinaryOperatorType.ExclusiveOr:
				return "^"
		elif op == BinaryOperatorType.ShiftLeft:
				return "<<"
		elif op == BinaryOperatorType.ShiftRight:
				return ">>"
		elif op == BinaryOperatorType.InPlaceShiftLeft:
				return "<<="
		elif op == BinaryOperatorType.InPlaceShiftRight:
				return ">>="
		
		elif op == BinaryOperatorType.Exponentiation:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) // "**" // TODO
		elif op == BinaryOperatorType.Member:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO "in"
		elif op == BinaryOperatorType.NotMember:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO "not in"
		elif op == BinaryOperatorType.ReferenceEquality:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO "is"
		elif op == BinaryOperatorType.ReferenceInequality:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO "is not"
		elif op == BinaryOperatorType.TypeTest:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO "isa"
		elif op == BinaryOperatorType.Match:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO return "=~"
		elif op == BinaryOperatorType.NotMatch:
				raise NotImplementedException( "Not Implemented: " + op.ToString( ) ) # TODO return "!~"
		raise NotImplementedException( "Not Implemented: " + op.ToString( ) )
		
