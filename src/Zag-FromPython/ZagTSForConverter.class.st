"
I am the ZagTSConverter for 'for' loops.
"
Class {
	#name : 'ZagTSForConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSForConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #for_statement putRule: self new
]

{ #category : 'converting' }
ZagTSForConverter >> convertToZagAST: aZagTSNode [
	^ASSend target: (aZagTSNode >> 2) asZagASTNode selector: #do: args: {
		ZagTSBlockConverter blockToZagAST: (aZagTSNode >> 3) children args: { (aZagTSNode >> 1) asZagASTNode } }
]
