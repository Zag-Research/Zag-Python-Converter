"
I am the ZagTSConverter for code blocks.
"
Class {
	#name : 'ZagTSBlockConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'converting' }
ZagTSBlockConverter class >> blockToZagAST: children args: args [
	"Converts a block of ZagTSNodes to a Zag block.  The args is arguments for the block."
	^ASBlockNode arguments: args locals: #() body: (
		children select: [ :each | each tsNodeType ~= #pass_statement ] thenCollect: #asZagASTNode
	).
]

{ #category : 'class initialization' }
ZagTSBlockConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #block putRule: self new
]

{ #category : 'converting' }
ZagTSBlockConverter >> convertToZagAST: aZagTSNode [
	^self class blockToZagAST: aZagTSNode children args: #()
]
