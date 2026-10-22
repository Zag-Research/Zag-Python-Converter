"
I am the ZagTSConverter for slices
"
Class {
	#name : 'ZagTSSliceConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSSliceConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #slice putRule: self new
]

{ #category : 'parsing' }
ZagTSSliceConverter class >> sliceIndices: aZagTSNode [
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
ZagTSSliceConverter >> convertToZagAST: aZagTSNode [
	| sliceIndices |
	sliceIndices := self class sliceIndices: aZagTSNode.
	^ASSend
		target: sliceIndices first
		selector: (#(nil #toExclusive: #toExclusive:by:) at: sliceIndices size)
		args: sliceIndices allButFirst
]
