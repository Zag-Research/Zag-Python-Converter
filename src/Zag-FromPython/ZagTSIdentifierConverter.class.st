"
I am the ZagTSConverter for identifiers (variables and some constants).
"
Class {
	#name : 'ZagTSIdentifierConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSIdentifierConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #identifier putRule: self new
]

{ #category : 'converting' }
ZagTSIdentifierConverter >> convertToZagAST: aZagTSNode [
	aZagTSNode sourcePart asSymbol = #NotImplemented ifTrue: [ ^ASLiteral literal: NotImplemented ].
	aZagTSNode sourcePart asSymbol = #Ellipsis ifTrue: [ ^ASLiteral literal: Ellipsis ].
	^ASRef variable: aZagTSNode sourcePart asSymbol.
]
