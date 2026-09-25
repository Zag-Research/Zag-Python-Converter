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
	^(aZagTSNode >> 1) tsNodeType = #subscript
		ifTrue: [ ASSend
			target: (aZagTSNode >> 1 >> 1) asZagASTNode 
			selector: #zwAt:put:
			args: { (aZagTSNode >> 1 >> 2) asZagASTNode . (aZagTSNode >> 2) asZagASTNode }.
		] ifFalse: [
			ASAssign variable: (aZagTSNode >> 1) asZagASTNode expression: (aZagTSNode >> 2) asZagASTNode
		].
]
