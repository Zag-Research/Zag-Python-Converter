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
ZagTSSubscriptConverter >> convertToZagAST: aZagTSNode [
	^ASSend
		target: (aZagTSNode >> 1) asZagASTNode
		selector: #zwAt:
		args: { (aZagTSNode >> 2) asZagASTNode }.
]
