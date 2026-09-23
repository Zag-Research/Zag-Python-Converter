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

{ #category : 'constants' }
ZagTSNode class >> builtinMap [
	"Return a dictionary mapping Python builtin function names to methods that should be called to convert them.  Functions outside this map are not yet supported."
	^{
		#print -> #printToZagAST.
		#input -> #inputToZagAST.
		#float -> #floatToZagAST.
		#int -> #intToZagAST.
		#range -> #rangeToZagAST.
		#bytearray -> #byteArrayToZagAST.
		#set -> #setCallToZagAST. "setToZagAST is taken by the set literal"
	} asDictionary
]

{ #category : 'computing' }
ZagTSNode class >> computeLocals: body [
	"Gets the set of local variables in a collection of statements."
	^body select: [ :each | each isKindOf: ASAssign ] thenCollect: #variable
]

{ #category : 'accessing' }
ZagTSNode class >> converter: type [
	"Returns the conversion function for a node of the given type (symbol)."
	"This function should accept the ZagTSNode and return a Zag AST object."
	type = #'if_statement' ifTrue: [ ^#ifToZagAST ].
	type = #'conditional_expression' ifTrue: [ ^#ifExpressionToZagAST ].
	type = #'for_statement' ifTrue: [ ^#forToZagAST ].
	type = #'while_statement' ifTrue: [ ^#whileToZagAST ].
	type = #'pass_statement' ifTrue: [
		self error: 'Pass statements convert to nothing, so they should be handled outside the converter system.'
	].
	^(type asString,'ToZagAST') asSymbol
]

{ #category : 'formatting' }
ZagTSNode class >> formatCode: code [
	"Formats code for handling by tree-sitter."
	| inString |
	inString := false.
	^String streamContents: [ :stream |
		code linesDo: [ :line |
			(line allRangesOfSubstring: '"""') size odd ifTrue: [ inString := inString not ].
			stream nextPutAll: line.
			(':;' includes: line last) | inString ifFalse: [
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
	^[
		ZagTSConverter convertToZagAST: self.
	] onErrorDo: [ :err | | converter |
		Transcript show: 'Error converting node type '; show: self tsNodeType; show: ': '; show: err; cr.
		converter := self class converter: self tsNodeType.
		converter value: self.
	]
]

{ #category : 'converting - control flow' }
ZagTSNode >> blockToZagAST [
	"Converts a block to a Zag AST."
	^self blockToZagASTArgs: #()
]

{ #category : 'converting - control flow' }
ZagTSNode >> blockToZagASTArgs: args [
	"Converts a block to a Zag AST.  The provided variable is arguments for the Zag block."
	^ASBlockNode arguments: args locals: #() body: (
		((1 to: self childrenCount)
			select: [ :i | (self >> i) tsNodeType ~= #'pass_statement' ])
			collect: [ :i | (self >> i) asZagASTNode ]
	).
]

{ #category : 'converting - functions' }
ZagTSNode >> builtinToZagAST [
	"Converts a builtin method to a Zag AST."
	^self class builtinMap
		at: (self >> 1) sourcePart asSymbol
		ifPresent: [ :func | func value: self ]
		ifAbsent: [ self notYetImplemented ]
]

{ #category : 'converting - functions' }
ZagTSNode >> byteArrayToZagAST [
	^ASSend target: (ASRef variable: #ByteArray) selector: #fromNumberOrString: args: {
		(self >> 2 >> 1) asZagASTNode }
]

{ #category : 'converting - functions' }
ZagTSNode >> callToZagAST [
	"Converts a function call to a Zag AST."
	(self class builtinMap includesKey: (self >> 1) sourcePart asSymbol)
		ifTrue: [ ^self builtinToZagAST ]
		ifFalse: [ self notYetImplemented ].
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
		(self >> 3) blockToZagASTArgs: { (self >> 1) asZagASTNode } }
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
ZagTSNode >> ifExpressionToZagAST [
	^ASSend
		target: (self >> 2) asZagASTNode
		selector: #ifTrue:ifFalse:
		args: (#(1 3) collect: [ :i | ASBlockNode locals: #() body: { (self >> i) asZagASTNode } ])
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

{ #category : 'converting - functions' }
ZagTSNode >> setCallToZagAST [
	^ASSend target: (self >> 2 >> 1) asZagASTNode selector: #asSet
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

{ #category : 'accessing' }
ZagTSNode >> tsNodeType [
	"Returns the type of my associated tree sitter node"
	^node type asSymbol.
]

{ #category : 'converting - control flow' }
ZagTSNode >> whileToZagAST [
	"Converts a while statement to a Zag AST."
	^ASSend target: (
		ASBlockNode arguments: #() locals: #() body: { (self >> 1) asZagASTNode }
	) selector: #whileTrue: args: { (self >> 2) asZagASTNode }.
]
