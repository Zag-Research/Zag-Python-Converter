"
I am the ZagTSConverter for conditional expressions ('a if b else c').
"
Class {
	#name : 'ZagTSIfExpressionConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSIfExpressionConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #conditional_expression putRule: self new
]

{ #category : 'converting' }
ZagTSIfExpressionConverter >> convertToZagAST: aZagTSNode [
	^ASSend
		target: (aZagTSNode >> 2) asZagASTNode
		selector: #ifTrue:ifFalse:
		args: (#(1 3) collect: [ :i |
			ASBlockNode locals: #() body: { (aZagTSNode >> i) asZagASTNode } ])
]
