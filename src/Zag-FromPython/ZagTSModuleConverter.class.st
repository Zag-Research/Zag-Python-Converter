"
I am the ZagTSConverter for modules.
"
Class {
	#name : 'ZagTSModuleConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSModuleConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #module putRule: self new
]

{ #category : 'converting' }
ZagTSModuleConverter >> convertToZagAST: aZagTSNode [
	| children locals |
	children := (1 to: aZagTSNode asTSNode namedChildCount)
		collect: [ :i | (aZagTSNode >> i) asZagASTNode ].
	locals := aZagTSNode class computeLocals: children.
	^ASMethodNode selector: aZagTSNode class mainMethodSelector locals: locals body: children.
]
