"
I am the ZagTSConverter for the raise statement.
"
Class {
	#name : 'ZagTSRaiseConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSRaiseConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #raise_statement putRule: self new
]

{ #category : 'converting' }
ZagTSRaiseConverter >> convertToZagAST: aZagTSNode [
	^ASSend target: (aZagTSNode >> 1) asZagASTNode selector: #signal
]
