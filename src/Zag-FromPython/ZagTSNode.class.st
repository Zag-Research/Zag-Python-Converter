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

{ #category : 'formatting' }
ZagTSNode class >> formatCode: code [
	"Formats code for handling by tree-sitter."
	^String streamContents: [ :stream |
		code linesDo: [ :line |
			stream nextPutAll: line.
			(':;' includes: line last) ifFalse: [
				stream nextPut: $;
			].
			stream nextPut: Character cr.
		]
	]
]

{ #category : 'constants' }
ZagTSNode class >> mainMethodSelector [
	"The selector used for the main method, where non-method code is put in."
	^#main.
]

{ #category : 'instance creation' }
ZagTSNode class >> newRoot: source [
	"Creates a new root node from the provided Python source."
	| formattedSource tree root |
	formattedSource := self formatCode: source.
	tree := self parsePythonTS: formattedSource.
	root := self new.
	root setNode: tree rootNode source: formattedSource.
	^root.
]

{ #category : 'instance creation' }
ZagTSNode class >> parsePythonTS: source [
	"Parses Python code with TreeSitter."
	| parser pythonLanguage tree |
	parser := TSParser new.
	pythonLanguage := TSLanguage python.
	parser language: pythonLanguage.
	tree := parser parseString: source.
	tree rootNode hasErrorDescendant
		ifTrue: [ self error: 'Tree-Sitter had an error parsing the provided source code.' ]
		ifFalse: [ ^tree ].
]

{ #category : 'converting' }
ZagTSNode class >> pythonToZagAST: source [
	"Converts the provided code to a Zag AST node."
	^(self newRoot: source) asZagASTNode.
]

{ #category : 'constants' }
ZagTSNode class >> supportedBuiltins [
	^#(#print #input #float #int #range) asSet.
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

{ #category : 'converting - operators' }
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

{ #category : 'converting - operators' }
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

{ #category : 'converting - operators' }
ZagTSNode >> binaryToZagAST [
	"Converts a binary operator to a Zag AST."
	| op |
	op := self getBinaryOperator.
	^self binaryToZagASTOperator: op.
]

{ #category : 'converting - operators' }
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

{ #category : 'converting - operators' }
ZagTSNode >> binaryToZagASTSelector: selector [
	"Creates a binary zag AST from this node's children using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {(self >> 2) asZagASTNode}.
]

{ #category : 'converting - control flow' }
ZagTSNode >> blockToZagAST [
	"Converts a block to a Zag AST."
	^ASBlockNode arguments: #() locals: #() body: (
		(1 to: self childrenCount) collect: [ :i | (self >> i) asZagASTNode ]
	).
]

{ #category : 'converting - operators' }
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

{ #category : 'converting - functions' }
ZagTSNode >> builtinToZagAST [
	"Converts a builtin method to a Zag AST."
	| name |
	name := (self >> 1) sourcePart asSymbol.
	name = #print ifTrue: [ ^self printToZagAST ].
	name = #input ifTrue: [ ^self inputToZagAST ].
	name = #float ifTrue: [ ^self floatToZagAST ].
	name = #int ifTrue: [ ^self intToZagAST ].
	name = #range ifTrue: [ ^self rangeToZagAST ].
]

{ #category : 'converting - functions' }
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

{ #category : 'converting - literals' }
ZagTSNode >> falseToZagAST [
	^ASLiteral literal: false.
]

{ #category : 'converting - functions' }
ZagTSNode >> floatToZagAST [
	^ASSend
		target: (self >> 2 >> 1) asZagASTNode
		selector: #asNumber.
]

{ #category : 'converting - control flow' }
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

{ #category : 'converting - control flow' }
ZagTSNode >> ifElifToZagAST [
	"Converts an if-elif statement to a Zag switch statement."
	"ASArray does not appear to work, so temporarily, this code returns an array object instead of an ASArray for the switch target."
	| conditions |
	conditions := ASArray new: self childrenCount - 1.
	conditions at: 1 put: (ASSend
		target: (ASSend target: (self >> 1) asZagASTNode selector: #asPythonBoolean)
		selector: #-> args: {(self >> 2) asZagASTNode}).
	3 to: self childrenCount do: [ :i |
		conditions at: i - 1 put: ((self >> i) tsNodeType = #'elif_clause'
			ifTrue: [ ASSend
				target: (ASSend target: (self >> i >> 1) asZagASTNode selector: #asPythonBoolean)
				selector: #-> args: {(self >> i >> 2) asZagASTNode } ]
			ifFalse: [ ASSend target: (ASLiteral literal: true) selector: #-> args: {(self >> i >> 1) asZagASTNode } ])].
	^ASSend target: conditions selector: #switch.
]

{ #category : 'converting - control flow' }
ZagTSNode >> ifToZagAST [
	"Converts an if statement to a Zag AST."
	"If the statement is just if or if/else, uses ifTrue: or ifTrue:ifFalse:.  Otherwise, uses a switch statement from ifElifToZagAST."
	| hasElse target |
	hasElse := (self >> (self childrenCount)) tsNodeType = #'else_clause'.
	target := ASSend target: (self >> 1) asZagASTNode selector: #asPythonBoolean.
	hasElse & (self childrenCount = 3) ifTrue: [
		^ASSend target: target selector: #ifTrue:ifFalse: args: { (self >> 2) asZagASTNode . (self >> self childrenCount >> 1) asZagASTNode }].
	hasElse not & (self childrenCount = 2) ifTrue: [
		^ASSend target: target selector: #ifTrue: args: { (self >> 2) asZagASTNode }].
	^self ifElifToZagAST.
]

{ #category : 'converting - functions' }
ZagTSNode >> inputToZagAST [
	^ASSend
		target: (ASSend target: (ASRef variable: #UIManager) selector: #default args: #())
		selector: #request:
		args: { (self >> 2 >> 1) asZagASTNode }.
]

{ #category : 'converting - functions' }
ZagTSNode >> intToZagAST [
	^ASSend
		target: (self >> 2 >> 1) asZagASTNode
		selector: #asInteger.
]

{ #category : 'converting - functions' }
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

{ #category : 'converting - operators' }
ZagTSNode >> notToZagAST [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	^ASSend target: (self >> 1) asZagASTNode selector: #pythonNot.
]

{ #category : 'converting - literals' }
ZagTSNode >> numberToZagAST [
	"Converts a number to a Zag AST."
	^ASLiteral literal: self sourcePart asNumber.
]

{ #category : 'converting - functions' }
ZagTSNode >> printToZagAST [
	| calls |
	calls := (self >> 2) children collect: [ :each |
		ASSend selector: #show: args: { each asZagASTNode } ].
	^ASCascade target: (ASRef variable: #Transcript) sends: (calls copyWith: (
		ASSend selector: #cr args: #())).
]

{ #category : 'converting - functions' }
ZagTSNode >> rangeToZagAST [
	^(self >> 2) children size = 2
		ifTrue: [ ASSend
			target: (self >> 2 >> 1) asZagASTNode
			selector: #toExclusive:
			args: { (self >> 2 >> 2) asZagASTNode } ]
		ifFalse: [ ASSend
			target: (self >> 2 >> 1) asZagASTNode
			selector: #toExclusive:by: 
			args: { (self >> 2 >> 2) asZagASTNode . (self >> 2 >> 3) asZagASTNode } ]
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

{ #category : 'converting - literals' }
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

{ #category : 'converting - literals' }
ZagTSNode >> trueToZagAST [
	^ASLiteral literal: true.
]

{ #category : 'accessing' }
ZagTSNode >> tsNodeType [
	"Returns the type of my associated tree sitter node"
	^node type asSymbol.
]

{ #category : 'converting - operators' }
ZagTSNode >> unaryToZagAST [
	"Converts a unary operator to a Zag AST."
	| op |
	op := self getUnaryOperator.
	op = #- ifTrue: [ ^self unaryToZagAST: #negated ].
	op = #~ ifTrue: [ ^self unaryToZagAST: #bitInvert ].
]

{ #category : 'converting - operators' }
ZagTSNode >> unaryToZagAST: selector [
	"Creates a unary zag AST from this node's child using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {}.
]

{ #category : 'converting - control flow' }
ZagTSNode >> whileToZagAST [
	"Converts a while statement to a Zag AST."
	^ASSend target: (
		ASBlockNode arguments: #() locals: #() body: { (self >> 1) asZagASTNode }
	) selector: #whileTrue: args: { (self >> 2) asZagASTNode }.
]
