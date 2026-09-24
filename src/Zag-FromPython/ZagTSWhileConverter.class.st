"
I am the ZagTSConverter for 'while' loops.
"
Class {
	#name : 'ZagTSWhileConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSWhileConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #while_statement putRule: self new
]

{ #category : 'converting' }
ZagTSWhileConverter >> convertToZagAST: aZagTSNode [
	^ASSend target: (
		ASBlockNode arguments: #() locals: #() body: { (aZagTSNode >> 1) asZagASTNode }
	) selector: #whileTrue: args: { (aZagTSNode >> 2) asZagASTNode }.
]
