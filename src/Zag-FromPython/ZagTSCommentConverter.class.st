"
I am the ZagTSConverter for comments.
"
Class {
	#name : 'ZagTSCommentConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSCommentConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #comment putRule: self new
]

{ #category : 'converting' }
ZagTSCommentConverter >> convertToZagAST: aZagTSNode [
	^ASComment text: aZagTSNode sourcePart allButFirst trimBoth
]
