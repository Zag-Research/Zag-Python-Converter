"
I am the ZagTSConverter for assert statements.
"
Class {
	#name : 'ZagTSAssertConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSAssertConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #assert_statement putRule: self new
]

{ #category : 'converting' }
ZagTSAssertConverter >> convertToZagAST: aZagTSNode [
	| assertBlock |
	assertBlock := ASBlockNode locals: #() body: { (aZagTSNode >> 1) asZagASTNode }.
	^aZagTSNode childrenCount = 1
		ifTrue: [ ASSend target: assertBlock selector: #assert ]
		ifFalse: [ ASSend target: assertBlock selector: #assertWithDescription: args: {
			(aZagTSNode >> 2) asZagASTNode } ].
]
