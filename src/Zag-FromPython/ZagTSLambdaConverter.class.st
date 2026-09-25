"
I am the ZagTSConverter for lambda expressions.
"
Class {
	#name : 'ZagTSLambdaConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSLambdaConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #lambda putRule: self new
]

{ #category : 'converting' }
ZagTSLambdaConverter >> convertToZagAST: aZagTSNode [
	| hasArguments arguments bodyStart children locals |
	aZagTSNode childrenCount < 1 ifTrue: [ self error: 'invalid lambda w/o children' ].
	hasArguments := (aZagTSNode >> 1) tsNodeType = #lambda_parameters.
	arguments := hasArguments ifTrue: [ (aZagTSNode >> 1) children collect: #asZagASTNode ] ifFalse: [ #() ].
	bodyStart := hasArguments ifTrue: [ 2 ] ifFalse: [ 1 ].
	children := (bodyStart to: aZagTSNode childrenCount) collect: [:i | (aZagTSNode >> i) asZagASTNode ].
	locals := aZagTSNode class computeLocals: children.
	^ASBlockNode arguments: arguments locals: locals body: children.
]
