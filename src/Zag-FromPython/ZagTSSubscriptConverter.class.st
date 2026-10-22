"
A ZagTSConverter for the a[b] notation.
"
Class {
	#name : 'ZagTSSubscriptConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSSubscriptConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #subscript putRule: self new
]

{ #category : 'converting' }
ZagTSSubscriptConverter >> convertSlice: aZagTSNode [
	"Convert a subscript containing a slice to a Zag AST node."
	| argumentParts selector |
	argumentParts := self class sliceIndices: aZagTSNode >> 2.
	selector := argumentParts size = 2 ifTrue: [ #zwCopyFrom:to: ] ifFalse: [ #zwCopyFrom:to:by: ].
	^ASSend
		target: (aZagTSNode >> 1) asZagASTNode
		selector: selector
		args: argumentParts.
]

{ #category : 'converting' }
ZagTSSubscriptConverter >> convertToZagAST: aZagTSNode [
	| args |
	args := aZagTSNode childrenCount = 2
		ifTrue: [ (aZagTSNode >> 2) asZagASTNode ]
		ifFalse: [ aZagTSNode children allButFirst collect: #asZagASTNode as: ASArray ].
	^ASSend target: (aZagTSNode >> 1) asZagASTNode selector: #zwAt: args: { args }.
]
