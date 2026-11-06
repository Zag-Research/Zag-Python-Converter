"
I am a converter for the with statement.
"
Class {
	#name : 'ZagTSWithConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSWithConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #with_statement putRule: self new
]

{ #category : 'converting' }
ZagTSWithConverter >> convertToZagAST: aZagTSNode [
	^ASSend
		target: (ASBlockNode locals: #() body: { (aZagTSNode >> 1 >> 1 >> 1 >> 1) asZagASTNode })
		selector: #ensureClosesAfter:
		args: { ZagTSBlockConverter blockToZagAST: (aZagTSNode >> 2) children args: {
			(aZagTSNode >> 1 >> 1 >> 1 >> 2 >> 1) asZagASTNode} }.
]
