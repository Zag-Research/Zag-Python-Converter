"
I am the converter for assignment statements.
"
Class {
	#name : 'ZagTSAssignConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSAssignConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #assignment putRule: self new.
	aClass at: #named_expression putRule: self new.
]

{ #category : 'converting' }
ZagTSAssignConverter >> convertToZagAST: aZagTSNode [
	^aZagTSNode childrenCount = 2 ifTrue: [
		(aZagTSNode >> 2) tsNodeType = #type ifTrue: [ 
			(aZagTSNode >> 1) asZagASTNode type: (aZagTSNode >> 2) asZagASTNode; yourself
		] ifFalse: [
			self convertVariable: aZagTSNode >> 1 expression: aZagTSNode >> 2
		]
	] ifFalse: [ | assign |
		assign := self convertVariable: aZagTSNode >> 1 expression: aZagTSNode >> 3.
		(assign isASAssign ifTrue: [ assign variable ] ifFalse: [ assign target ])
			 type: (aZagTSNode >> 2) asZagASTNode.
		assign
	]
]

{ #category : 'converting' }
ZagTSAssignConverter >> convertVariable: variable expression: expression [
	^variable tsNodeType = #subscript
		ifTrue: [ ASSend
			target: (variable >> 1) asZagASTNode 
			selector: #zwAt:put:
			args: { (variable >> 2) asZagASTNode . expression asZagASTNode }.
		] ifFalse: [
			ASAssign variable: variable asZagASTNode expression: expression asZagASTNode
		].
]
