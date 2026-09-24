"
I am the ZagTSConverter for if/elif/else statements.
"
Class {
	#name : 'ZagTSIfConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSIfConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #if_statement putRule: self new
]

{ #category : 'converting' }
ZagTSIfConverter >> convertToZagAST: aZagTSNode [
	"If the statement is just if or if/else, uses ifTrue: or ifTrue:ifFalse:.  Otherwise, uses a switch statement from ifElifToZagAST."
	| hasElse target |
	hasElse := (aZagTSNode >> (aZagTSNode childrenCount)) tsNodeType = #'else_clause'.
	target := ASSend target: (aZagTSNode >> 1) asZagASTNode selector: #asPythonBoolean.
	hasElse & (aZagTSNode childrenCount = 3) ifTrue: [
		^ASSend target: target selector: #ifTrue:ifFalse: args: { (aZagTSNode >> 2) asZagASTNode . (aZagTSNode >> aZagTSNode childrenCount >> 1) asZagASTNode }].
	hasElse not & (aZagTSNode childrenCount = 2) ifTrue: [
		^ASSend target: target selector: #ifTrue: args: { (aZagTSNode >> 2) asZagASTNode }].
	^self ifElifToZagSwitch: aZagTSNode.
]

{ #category : 'converting' }
ZagTSIfConverter >> ifElifToZagSwitch: aZagTSNode [
	"Convert a ZagTSNode representing an if-elif-else statement to a Zag switch statement."
	| conditions |
	conditions := ASArray new: aZagTSNode childrenCount - 1.
	conditions at: 1 put: (ASSend
		target: (ASSend target: (aZagTSNode >> 1) asZagASTNode selector: #asPythonBoolean)
		selector: #-> args: {(aZagTSNode >> 2) asZagASTNode}).
	3 to: aZagTSNode childrenCount do: [ :i |
		conditions at: i - 1 put: ((aZagTSNode >> i) tsNodeType = #'elif_clause'
			ifTrue: [ ASSend
				target: (ASSend target: (aZagTSNode >> i >> 1) asZagASTNode selector: #asPythonBoolean)
				selector: #-> args: {(aZagTSNode >> i >> 2) asZagASTNode } ]
			ifFalse: [ ASSend target: (ASLiteral literal: true) selector: #-> args: {(aZagTSNode >> i >> 1) asZagASTNode } ])].
	^ASSend target: conditions selector: #switch.
]
