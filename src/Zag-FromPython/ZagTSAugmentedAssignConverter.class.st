"
I am the ZagTSConverter for augmented assigns (e.g. +=).
"
Class {
	#name : 'ZagTSAugmentedAssignConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSAugmentedAssignConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #augmented_assignment putRule: self new
]

{ #category : 'converting' }
ZagTSAugmentedAssignConverter >> arrayAssignToZagAST: aZagTSNode op: op [
	^ASSend
		target: (aZagTSNode >> 1 >> 1) asZagASTNode 
		selector: #zwAt:put:
		args: { (aZagTSNode >> 1 >> 2) asZagASTNode . ZagTSBinaryOperatorConverter
			convertToZagASTSelector: op
			left: (MockZagTSNode new zagAST: (ASSend
				target: (aZagTSNode >> 1 >> 1) asZagASTNode 
				selector: #zwAt:
				args: { (aZagTSNode >> 1 >> 2) asZagASTNode }))
			right: aZagTSNode >> 2 }.
]

{ #category : 'converting' }
ZagTSAugmentedAssignConverter >> convertToZagAST: aZagTSNode [
	| nonAugmentedOp |
	nonAugmentedOp := aZagTSNode getBinaryOperator asString allButLast asSymbol.
	^(aZagTSNode >> 1) tsNodeType = #subscript
		ifTrue: [
			self arrayAssignToZagAST: aZagTSNode op: nonAugmentedOp
		] ifFalse: [
			self regularAssignToZagAST: aZagTSNode op: nonAugmentedOp
		].
]

{ #category : 'converting' }
ZagTSAugmentedAssignConverter >> regularAssignToZagAST: aZagTSNode op: op [
	^ASAssign variable: (aZagTSNode >> 1) asZagASTNode expression: (
		ZagTSBinaryOperatorConverter
			convertToZagASTSelector: op
			left: aZagTSNode >> 1
			right: aZagTSNode >> 2
	)
]
