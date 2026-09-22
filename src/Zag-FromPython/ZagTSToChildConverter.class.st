"
I am a ZagTSConverter that just returns one of a node's children converted.  #childNumber determines which child I return converted.
"
Class {
	#name : 'ZagTSToChildConverter',
	#superclass : 'ZagTSConverter',
	#instVars : [
		'childNumber'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSToChildConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #expression_statement putRule: (self new childNumber: 1).
	aClass at: #parenthesized_expression putRule: (self new childNumber: 1).
]

{ #category : 'accessing' }
ZagTSToChildConverter >> childNumber [

	^ childNumber
]

{ #category : 'accessing' }
ZagTSToChildConverter >> childNumber: anObject [

	childNumber := anObject
]

{ #category : 'converting' }
ZagTSToChildConverter >> convertToZagAST: aZagTSNode [
	^(aZagTSNode >> self childNumber) asZagASTNode.
]
