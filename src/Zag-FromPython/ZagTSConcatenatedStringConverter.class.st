"
I convert concatenated string literals to Zag.
"
Class {
	#name : 'ZagTSConcatenatedStringConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSConcatenatedStringConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #concatenated_string putRule: self new
]

{ #category : 'converting' }
ZagTSConcatenatedStringConverter >> convertToZagAST: aZagTSNode [
	^self getConcatenatingASSend: (aZagTSNode children collect: #asZagASTNode) endingAt: aZagTSNode childrenCount
]

{ #category : 'converting' }
ZagTSConcatenatedStringConverter >> getConcatenatingASSend: translatedChildren endingAt: n [
	n < 1 ifTrue: [ self error: 'Invalid endingAt value.' ].
	n = 1 ifTrue: [ ^translatedChildren first ].
	^ASSend
		target: (self getConcatenatingASSend: translatedChildren endingAt: n - 1)
		selector: #,
		args: { translatedChildren at: n }
]
