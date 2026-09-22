"
I am the ZagTSConverter for the del statement.
"
Class {
	#name : 'ZagTSDeleteConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSDeleteConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #delete_statement putRule: self new
]

{ #category : 'converting' }
ZagTSDeleteConverter >> convertToZagAST: aZagTSNode [
	(aZagTSNode >> 1) tsNodeType = #subscript ifFalse: [ ^self notYetImplemented ].
	^ASSend
		target: (aZagTSNode >> 1 >> 1) asZagASTNode
		selector: #removeAt:
		args: { (aZagTSNode >> 1 >> 2) asZagASTNode }.
]
