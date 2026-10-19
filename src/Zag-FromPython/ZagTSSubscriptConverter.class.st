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
	^ASSend
		target: (aZagTSNode >> 1) asZagASTNode
		selector: #zwCopyFrom:to:
		args: { (aZagTSNode >> 2 >> 1) asZagASTNode . (aZagTSNode >> 2 >> 2) asZagASTNode } 
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
