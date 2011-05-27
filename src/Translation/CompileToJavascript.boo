namespace Translation

import Boo.Lang.Compiler.Steps
import Boo.Lang.Compiler.Pipelines
	
public class CompileToJavascript( Parse ):
	def constructor( ):
		
		BreakOnErrors = true
		
		Add( PreErrorChecking( ) )

		mergePartialTypes = MergePartialTypes( )
		Add( mergePartialTypes )

		Add( InitializeNameResolutionService( ) )
		Add( IntroduceGlobalNamespaces( ) )
		Add( TransformCallableDefinitions( ) )

		Add( BindTypeDefinitions( ) )
		Add( BindGenericParameters( ) )
		Add( ResolveImports( ) )
		Add( BindBaseTypes( ) )
		
		# print -> System.Console.WriteLine
		Add( MacroAndAttributeExpansion( ) )
		
		Add( mergePartialTypes )
	
		
		Add( ExpandAstLiterals( ) )
			
		Add( IntroduceModuleClasses( ) )
		Add( NormalizeStatementModifiers( ) )
		Add( NormalizeTypeAndMemberDefinitions( ) )
		Add( NormalizeExpressions( ) )

		Add( BindTypeDefinitions( ) )
		Add( BindGenericParameters( ) )
		Add( BindEnumMembers( ) )
		Add( BindBaseTypes( ) )
		Add( CheckMemberTypes( ) )

		
		Add( BindMethods( ) )
		Add( ResolveTypeReferences( ) )
		Add( BindTypeMembers( ) )
		Add( CheckGenericConstraints( ) )
		
		Add( ProcessInheritedAbstractMembers( ) )
		Add( CheckMemberNames( ) )
		
		# does most stuff
		Add( ProcessMethodBodiesForJavascript( ) )
		

		Add( ReifyTypes( ) )
		
		Add( TypeInference( ) )
		
		Add( InjectImplicitBooleanConversions( ) )

		Add( ConstantFolding( ) )

		Add( CheckLiteralValues( ) )

		Add( OptimizeIterationStatements( ) )

		
		Add( BranchChecking( ) )

		Add( VerifyExtensionMethods( ) )

		Add( CheckIdentifiers( ) )
		Add( StricterErrorChecking( ) )
		Add( DetectNotImplementedFeatureUsage( ) )
		Add( CheckAttributesUsage( ) )
		
		Add( ExpandDuckTypedExpressions( ) )
		
		
		
		Add( ProcessAssignmentsToValueTypeMembers( ) )
		Add( ExpandPropertiesAndEvents( ) )
		
		Add( CheckMembersProtectionLevel( ) )
		
		# adds .GetEnumerator( ) to iterables and transforms those fors into whiles
		Add( NormalizeIterationStatements( ) )


		Add( ProcessSharedLocals( ) )
		Add( ProcessClosures( ) )
		Add( ProcessGenerators( ) )
		
		Add( ExpandVarArgsMethodInvocations( ) )
		
		# probably don't need these
		Add( InjectCallableConversions( ) )
		Add( ImplementICallableOnCallableDefinitions( ) )

		Add( RemoveDeadCode( ) )
		Add( CheckNeverUsedMembers( ) )
		Add( CacheRegularExpressionsInStaticFields( ) )
		
		# TODO: boil down multiple dispatch methods / constructors
		# TODO: boil down exception handlers
		
		# turn getters/setters into methods and to call __defineSetter__ in constructor
		Add( ReformPropertiesForJavascript( ) )
		
		#Add( PrintBoo( ) )
		
		Add( JavascriptTranslationStep( ) )
		
