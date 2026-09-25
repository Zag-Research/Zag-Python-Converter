"
I am the ZagTSConverter for Python operators.
"
Class {
	#name : 'ZagTSOperatorConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSOperatorConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	self subclassesDo: [ :subclass | subclass putRules: aClass ]
]

{ #category : 'constants' }
ZagTSOperatorConverter class >> pythonToZagOperatorMap [
	"Returns a dictionary mapping Python operators to Zag selectors."
	self subclassResponsibility
]

{ #category : 'converting' }
ZagTSOperatorConverter class >> zagOperatorASTFromSelector: aSelector children: children [
	^ASSend
		target: children first asZagASTNode
		selector: aSelector
		args: (children allButFirst collect: #asZagASTNode)  
]

{ #category : 'converting' }
ZagTSOperatorConverter >> convertToZagAST: aZagTSNode [
	| zagSelector |
	zagSelector := self class pythonToZagOperatorMap at: (self pythonOperator: aZagTSNode).
	^self class zagOperatorASTFromSelector: zagSelector children: aZagTSNode children.
]

{ #category : 'converting' }
ZagTSOperatorConverter >> pythonOperator: aZagTSNode [
	"Returns the Python operator name corresponding to this ZagTSNode."
	self subclassResponsibility
]
