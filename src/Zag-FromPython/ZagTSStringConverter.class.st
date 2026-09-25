"
I am the ZagTSConverter for string literals.
"
Class {
	#name : 'ZagTSStringConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSStringConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #string putRule: self new
]

{ #category : 'converting' }
ZagTSStringConverter >> convertToZagAST: aZagTSNode [
	^ASLiteral literal: (aZagTSNode >> 2) sourcePart.
]
