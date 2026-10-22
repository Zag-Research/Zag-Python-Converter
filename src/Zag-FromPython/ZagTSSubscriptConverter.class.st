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

{ #category : 'parsing' }
ZagTSSubscriptConverter class >> sliceIndices: aZagTSNode [
	"Accepts a slice-type ZagTSNode, and returns its index parts as Zag AST nodes, with missing parts filled in."
	| parts nextChildIndex nextPartIndex |
	parts := { 0 . nil . 1 } collect: [ :each | ASLiteral literal: each ].
	nextChildIndex := 1.
	nextPartIndex := 1.
	$: split: aZagTSNode sourcePart do: [ :part |
		part isAllSeparators ifFalse: [
			parts at: nextPartIndex put: (aZagTSNode >> nextChildIndex) asZagASTNode.
			nextChildIndex := nextChildIndex + 1.
		].
		nextPartIndex := nextPartIndex + 1.
	].
	^parts copyFrom: 1 to: nextPartIndex - 1.
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
	(aZagTSNode >> 2) tsNodeType = #slice
		ifTrue: [ ^self convertSlice: aZagTSNode ].
	^ASSend
		target: (aZagTSNode >> 1) asZagASTNode
		selector: #zwAt:
		args: { (aZagTSNode >> 2) asZagASTNode }.
]
