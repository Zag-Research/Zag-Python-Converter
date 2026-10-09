"
I am the ZagTSBuiltinConverter for the range() call.
"
Class {
	#name : 'ZagTSRangeConverter',
	#superclass : 'ZagTSBuiltinConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSRangeConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	aClass at: #range putBuiltinRule: self new
]

{ #category : 'converting' }
ZagTSRangeConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	^({
		1 -> [ self oneArgToZagAST: aBuiltin ].
		2 -> [ self twoArgsToZagAST: aBuiltin ].
		3 -> [ self threeArgsToZagAST: aBuiltin ]
	} asDictionary "using a dictionary instead of array to easily raise a custom error with ifAbsent"
		at: (aBuiltin >> 2) children size
		ifAbsent: [ self error: 'Invalid number of arguments for range call' ]) value.
]

{ #category : 'converting' }
ZagTSRangeConverter >> oneArgToZagAST: aBuiltin [
	"Converts a one-argument range call to a Zag AST."
	^ASSend
		target: (ASLiteral literal: 0)
		selector: #toExclusive:
		args: { (aBuiltin >> 2 >> 1) asZagASTNode }
]

{ #category : 'converting' }
ZagTSRangeConverter >> threeArgsToZagAST: aBuiltin [
	"Converts a three-argument range call to a Zag AST."
	^ASSend
		target: (aBuiltin >> 2 >> 1) asZagASTNode
		selector: #toExclusive:by: 
		args: { (aBuiltin >> 2 >> 2) asZagASTNode . (aBuiltin >> 2 >> 3) asZagASTNode } 
]

{ #category : 'converting' }
ZagTSRangeConverter >> twoArgsToZagAST: aBuiltin [
	"Converts a two-argument range call to a Zag AST."
	^ASSend
		target: (aBuiltin >> 2 >> 1) asZagASTNode
		selector: #toExclusive:
		args: { (aBuiltin >> 2 >> 2) asZagASTNode }
]
