"
I am the ZagTSConverter for numbers.
"
Class {
	#name : 'ZagTSNumberConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSNumberConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #integer putRule: self new.
	aClass at: #float putRule: self new.
]

{ #category : 'converting' }
ZagTSNumberConverter >> convertToZagAST: aZagTSNode [
	(aZagTSNode sourcePart endsWith: 'j') ifTrue: [ ^ASSend target: (
		ASLiteral literal: aZagTSNode sourcePart allButLast asNumber) selector: #i ].
	^ASLiteral literal: aZagTSNode sourcePart asNumber.
]
