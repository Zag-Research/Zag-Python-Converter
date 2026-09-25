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
