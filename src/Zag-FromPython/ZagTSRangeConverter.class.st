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
	^(aBuiltin >> 2) children size = 2
		ifTrue: [ ASSend
			target: (aBuiltin >> 2 >> 1) asZagASTNode
			selector: #toExclusive:
			args: { (aBuiltin >> 2 >> 2) asZagASTNode } ]
		ifFalse: [ ASSend
			target: (aBuiltin >> 2 >> 1) asZagASTNode
			selector: #toExclusive:by: 
			args: { (aBuiltin >> 2 >> 2) asZagASTNode . (aBuiltin >> 2 >> 3) asZagASTNode } ]
]
