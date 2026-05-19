"
I represent a TSNode with its associated source code, ready to be converted to Zag.
"
Class {
	#name : 'ZagTSNode',
	#superclass : 'Object',
	#instVars : [
		'node',
		'source'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'computing' }
ZagTSNode class >> computeLocals: body [
	"Gets the set of local variables in a collection of statements."
	^body select: [ :each | each isKindOf: ASAssign ] thenCollect: #variable
]

{ #category : 'accessing' }
ZagTSNode class >> converter: type [
	"Returns the conversion function for a node of the given type (symbol)."
	"This function should accept the ZagTSNode and return a Zag AST object."
	(#(#'expression_statement' #'parenthesized_expression') includes: type) ifTrue: [ ^#childToZagAST ].
	(#(#integer #float) includes: type) ifTrue: [ ^#numberToZagAST ].
	type = #'not_operator' ifTrue: [ ^#notToZagAST ].
	type = #'unary_operator' ifTrue: [ ^#unaryToZagAST ].
	(#(#'binary_operator' #'comparison_operator') includes: type) ifTrue: [ ^#binaryToZagAST ].
	type = #'boolean_operator' ifTrue: [ ^#booleanToZagAST ].
	type = #assignment ifTrue: [ ^#assignToZagAST ].
	type = #'augmented_assignment' ifTrue: [ ^#augmentedAssignToZagAST ].
	type = #'named_expression' ifTrue: [ ^#assignToZagAST ]. ":= - temp - should have different semantics later"
	type = #'if_statement' ifTrue: [ ^#ifToZagAST ].
	type = #'for_statement' ifTrue: [ ^#forToZagAST ].
	type = #'while_statement' ifTrue: [ ^#whileToZagAST ].
	^(type asString,'ToZagAST') asSymbol
]

{ #category : 'constants' }
ZagTSNode class >> mainMethodSelector [
	"The selector used for the main method, where non-method code is put in."
	^#main.
]

{ #category : 'instance creation' }
ZagTSNode class >> newRoot: source [
	"Creates a new root node from the provided Python source."
	| tree root |
	tree := self parsePythonTS: source.
	root := self new.
	root setNode: tree rootNode source: source.
	^root.
]

{ #category : 'instance creation' }
ZagTSNode class >> parsePythonTS: source [
	"Parses Python code with TreeSitter."
	| parser pythonLanguage |
	parser := TSParser new.
	pythonLanguage := TSLanguage python.
	parser language: pythonLanguage.
	^parser parseString: source.
]

{ #category : 'converting' }
ZagTSNode class >> pythonToZagAST: source [
	"Converts the provided code to a Zag AST node."
	^(self newRoot: source) asZagASTNode.
]

{ #category : 'constants' }
ZagTSNode class >> supportedBuiltins [
	^#(#print #input #float).
]

{ #category : 'accessing' }
ZagTSNode >> >> n [
	"Returns the nth child of this node, as a ZagTSNode."
	| child |
	(n <= 0 or: [ n > node namedChildCount ])
		ifTrue: [ self error: 'invalid child number' ].
	child := self class new.
	child setNode: (node namedChildAt: n) source: source.
	^child.
]

{ #category : 'converting' }
ZagTSNode >> asTSNode [
	^node.
]

{ #category : 'converting' }
ZagTSNode >> asZagASTNode [
	"Returns me as a Zag AST node."
	| converter |
	converter := self class converter: self tsNodeType.
	^converter value: self.
]

{ #category : 'converting - by node type' }
ZagTSNode >> assignToZagAST [
	^(self >> 1) tsNodeType = #subscript
		ifTrue: [ ASSend
			target: (self >> 1 >> 1) asZagASTNode 
			selector: #zwAt:put:
			args: { (self >> 1 >> 2) asZagASTNode . (self >> 2) asZagASTNode }.
		] ifFalse: [
			ASAssign variable: (self >> 1) asZagASTNode expression: (self >> 2) asZagASTNode
		].
]

{ #category : 'converting - by node type' }
ZagTSNode >> augmentedAssignToZagAST [
	| op nonAugmentedOp |
	op := self getBinaryOperator.
	nonAugmentedOp := (op asString copyFrom: 1 to: (op asString size - 1)) asSymbol.
	^(self >> 1) tsNodeType = #subscript
		ifTrue: [ ASSend
			target: (self >> 1 >> 1) asZagASTNode 
			selector: #zwAt:put:
			args: { (self >> 1 >> 2) asZagASTNode . ASSend
				target: (ASSend
					target: (self >> 1 >> 1) asZagASTNode 
					selector: #zwAt:
					args: { (self >> 1 >> 2) asZagASTNode })
				selector: nonAugmentedOp
				args: { (self >> 2) asZagASTNode } }.
		] ifFalse: [
			ASAssign variable: (self >> 1) asZagASTNode expression: (self binaryToZagASTOperator: nonAugmentedOp)
		].
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagAST [
	"Converts a binary operator to a Zag AST."
	| op |
	op := self getBinaryOperator.
	^self binaryToZagASTOperator: op.
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagASTOperator: op [
	"Creates a binary zag AST from this node's children using the provided Python operator."
	(#(#+ #- #* #/ #// #% #& #| #< #<= #> #>=) includes: op) ifTrue: [ ^self binaryToZagASTSelector: op ].
	op = #** ifTrue: [ ^self binaryToZagASTSelector: #raisedTo: ].
	op = #'^' ifTrue: [ ^self binaryToZagASTSelector: #bitXor: ].
	op = #<< ifTrue: [ ^self binaryToZagASTSelector: #bitShift: ].
	op = #>> ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #bitShift: args: {
			ASSend target: (self >> 2) asZagASTNode selector: #negated args: #() } ].
	op = #== ifTrue: [ ^self binaryToZagASTSelector: #= ].
	op = #!= ifTrue: [ ^self binaryToZagASTSelector: #~= ].
	op = #is ifTrue: [ ^self binaryToZagASTSelector: #== ].
	op = #'is not' ifTrue: [ ^self binaryToZagASTSelector: #~~ ].
	op = #in ifTrue: [ ^ASSend target: (self >> 2) asZagASTNode selector: #includes: args: {(self >> 1) asZagASTNode} ].
	op = #'not in' ifTrue: [ ^ASSend target: (ASSend target: (self >> 2) asZagASTNode selector: #includes: args: {(self >> 1) asZagASTNode}) selector: #not args: #() ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagASTSelector: selector [
	"Creates a binary zag AST from this node's children using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {(self >> 2) asZagASTNode}.
]

{ #category : 'converting - by node type' }
ZagTSNode >> blockToZagAST [
	"Converts a block to a Zag AST."
	^ASBlockNode arguments: #() locals: #() body: (
		(1 to: self childrenCount) collect: [ :i | (self >> i) asZagASTNode ]
	).
]

{ #category : 'converting - by node type' }
ZagTSNode >> booleanToZagAST [
	"convert and/or to Zag AST"
 	| op |
	op := self getBinaryOperator.
	op = #and ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #pythonAnd:
			args: {ASBlockNode arguments: #() locals: #() body: {(self >> 2) asZagASTNode}} ].
	op = #or ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #pythonOr:
			args: {ASBlockNode arguments: #() locals: #() body: {(self >> 2) asZagASTNode}} ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> builtinToZagAST [
	"Converts a builtin method to a Zag AST."
	| name |
	name := (self >> 1) sourcePart asSymbol.
	name = #print ifTrue: [ ^self printToZagAST ].
	name = #input ifTrue: [ ^self inputToZagAST ].
	name = #float ifTrue: [ ^self floatToZagAST ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> callToZagAST [
	"Converts a function call to a Zag AST."
	(self class supportedBuiltins includes: (self >> 1) sourcePart asSymbol)
		ifTrue: [ ^self builtinToZagAST ]
		ifFalse: [ self error ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> childToZagAST [
	"Returns my first child as a Zag AST."
	^(self >> 1) asZagASTNode.
]

{ #category : 'accessing' }
ZagTSNode >> children [
	"Returns my children as a collection."
	^(1 to: self childrenCount) collect: [ :i | self >> i ].
]

{ #category : 'accessing' }
ZagTSNode >> childrenCount [
	^node namedChildCount.
]

{ #category : 'accessing' }
ZagTSNode >> childrenDo: aBlock [
	"Runs aBlock once for each of my children."
	1 to: self childrenCount do: [ :i | aBlock value: (self >> i) ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> floatToZagAST [
	^ASSend
		target: (self >> 2 >> 1) asZagASTNode
		selector: #asFloat.
]

{ #category : 'converting - by node type' }
ZagTSNode >> forToZagAST [
	"Converts for loop nodes to Zag AST."
	^ASSend target: (self >> 2) asZagASTNode selector: #do: args: {
		ASBlockNode arguments: { (self >> 1) asZagASTNode } locals: #() body: (
			(self >> 3) children collect: #asZagASTNode )}.
]

{ #category : 'computing' }
ZagTSNode >> getBinaryOperator [
	"If I represent a binary operator, return the operator I represent."
	| start end |
	start := ((self >> 1) asTSNode endPositionFromSourceText: source) + 1.
	end := ((self >> 2) asTSNode startPositionFromSourceText: source) - 1.
	^(source copyFrom: start to: end) trimBoth asSymbol.
]

{ #category : 'computing' }
ZagTSNode >> getUnaryOperator [
	"If I represent a unary operator, return the operator I represent."
	| start end |
	start := self asTSNode startPositionFromSourceText: source.
	end := ((self >> 1) asTSNode startPositionFromSourceText: source) - 1.
	^(source copyFrom: start to: end) trimBoth asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> identifierToZagAST [
	"Converts me to a Zag AST, assuming I am an identifier."
	^ASRef variable: self sourcePart asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> ifElifToZagAST [
	"Converts an if-elif statement to a Zag switch statement."
	"ASArray does not appear to work, so temporarily, this code returns an array object instead of an ASArray for the switch target."
	| conditions |
	conditions := Array new: self childrenCount - 1.
	conditions at: 1 put: (ASSend target: (self >> 1) asZagASTNode selector: #-> args: {(self >> 2) asZagASTNode}).
	3 to: self childrenCount do: [ :i |
		conditions at: i - 1 put: ((self >> i) tsNodeType = #'elif_clause'
			ifTrue: [ ASSend target: (self >> i >> 1) asZagASTNode selector: #-> args: {(self >> i >> 2) asZagASTNode } ]
			ifFalse: [ ASSend target: (ASLiteral literal: true) selector: #-> args: {(self >> i >> 1) asZagASTNode } ])].
	^ASSend target: conditions selector: #switch.
]

{ #category : 'converting - by node type' }
ZagTSNode >> ifToZagAST [
	"Converts an if statement to a Zag AST."
	"If the statement is just if or if/else, uses ifTrue: or ifTrue:ifFalse:.  Otherwise, uses a switch statement from ifElifToZagAST."
	| hasElse |
	hasElse := (self >> (self childrenCount)) tsNodeType = #'else_clause'.
	hasElse & (self childrenCount = 3) ifTrue: [
		^ASSend target: (self >> 1) asZagASTNode selector: #ifTrue:ifFalse: args: { (self >> 2) asZagASTNode . (self >> self childrenCount >> 1) asZagASTNode }].
	hasElse not & (self childrenCount = 2) ifTrue: [
		^ASSend target: (self >> 1) asZagASTNode selector: #ifTrue: args: { (self >> 2) asZagASTNode }].
	^self ifElifToZagAST.
]

{ #category : 'converting - by node type' }
ZagTSNode >> inputToZagAST [
	^ASSend
		target: (ASSend target: UIManager selector: #default args: #())
		selector: #request:
		args: { (self >> 2 >> 1) asZagASTNode }.
]

{ #category : 'converting - by node type' }
ZagTSNode >> lambdaToZagAST [
	"Converts me to a Zag AST, assuming I am a lambda."
	| hasArguments arguments bodyStart children locals |
	self childrenCount < 1 ifTrue: [ self error: 'invalid lambda w/o children' ].
	hasArguments := (self >> 1) tsNodeType = #lambda_parameters.
	arguments := hasArguments ifTrue: [ (self >> 1) children collect: #asZagASTNode ] ifFalse: [ #() ].
	bodyStart := hasArguments ifTrue: [ 2 ] ifFalse: [ 1 ].
	children := (bodyStart to: self childrenCount) collect: [:i | (self >> i) asZagASTNode ].
	locals := self class computeLocals: children.
	^ASBlockNode arguments: arguments locals: locals body: children.
]

{ #category : 'converting - by node type' }
ZagTSNode >> moduleToZagAST [
	"Converts a module to a #main method."
	| children locals |
	children := (1 to: node namedChildCount)
		collect: [ :i | (self >> i) asZagASTNode ].
	locals := self class computeLocals: children.
	^ASMethodNode selector: self class mainMethodSelector locals: locals body: children.
]

{ #category : 'converting - by node type' }
ZagTSNode >> notToZagAST [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	^ASSend target: (self >> 1) asZagASTNode selector: #pythonNot.
]

{ #category : 'converting - by node type' }
ZagTSNode >> numberToZagAST [
	"Converts a number to a Zag AST."
	^ASLiteral literal: self sourcePart asNumber.
]

{ #category : 'converting - by node type' }
ZagTSNode >> printToZagAST [
	| calls |
	calls := (self >> 2) children collect: [ :each |
		ASSend selector: #show: args: { each asZagASTNode } ].
	^ASCascade target: Transcript sends: (calls copyWith: (
		ASSend selector: #cr args: #())).
]

{ #category : 'initialization' }
ZagTSNode >> setNode: aNode source: aString [
	node := aNode.
	source := aString.
]

{ #category : 'accessing' }
ZagTSNode >> sourceFull [
	"Returns the complete source code of the tree this node was created with."
	^source.
]

{ #category : 'accessing' }
ZagTSNode >> sourcePart [
	"Returns the part of the source code associated with this node."
	^node textFromSourceText: source.
]

{ #category : 'converting - by node type' }
ZagTSNode >> stringToZagAST [
	"Converts a string to a Zag AST."
	^ASLiteral literal: (self >> 2) sourcePart.
]

{ #category : 'converting - by node type' }
ZagTSNode >> subscriptToZagAST [
	^ASSend
		target: (self >> 1) asZagASTNode
		selector: #zwAt:
		args: { (self >> 2) asZagASTNode }.
]

{ #category : 'accessing' }
ZagTSNode >> tsNodeType [
	"Returns the type of my associated tree sitter node"
	^node type asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> unaryToZagAST [
	"Converts a unary operator to a Zag AST."
	| op |
	op := self getUnaryOperator.
	op = #- ifTrue: [ ^self unaryToZagAST: #negated ].
	op = #~ ifTrue: [ ^self unaryToZagAST: #bitInvert ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> unaryToZagAST: selector [
	"Creates a unary zag AST from this node's child using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {}.
]

{ #category : 'converting - by node type' }
ZagTSNode >> whileToZagAST [
	"Converts a while statement to a Zag AST."
	^ASSend target: (
		ASBlockNode arguments: #() locals: #() body: { (self >> 1) asZagASTNode }
	) selector: #whileTrue: args: { (self >> 2) asZagASTNode }.
]
