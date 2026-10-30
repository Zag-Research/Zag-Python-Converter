"
I am the ZagTSConverter for the try statement
"
Class {
	#name : 'ZagTSTryConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'constants' }
ZagTSTryConverter class >> exceptSwitchVariableName [
	"The variable name used for except switches."
	"Only one is necessary, even for try-except in an except, because it is a local variable that is only used in one place, the switch keys."
	^#zagExceptException
]

{ #category : 'class initialization' }
ZagTSTryConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #try_statement putRule: self new
]

{ #category : 'converting' }
ZagTSTryConverter >> convertToZagAST: aZagTSNode [
	(aZagTSNode childrenCount = 2 and: [ (aZagTSNode >> 2) tsNodeType = #except_clause ])
		ifTrue: [ ^self trySingleExceptToZagAST: aZagTSNode ].
	(aZagTSNode children allButFirst allSatisfy: [ :c | c tsNodeType = #except_clause ])
		ifTrue: [ ^self tryExceptToZagSwitch: aZagTSNode ].
	self notYetImplemented.
]

{ #category : 'converting' }
ZagTSTryConverter >> exceptToZagCase: aZagTSNode switchVariable: anASRef [
	"Converts a single except clause to a single case of a switch statement."
	^ASSend
		target: (ASSend target: anASRef selector: #isKindOf: args: { (aZagTSNode >> 1 >> 1) asZagASTNode })
		selector: #->
		args: { ASBlockNode
			arguments: { (aZagTSNode >> 1 >> 2 >> 1) asZagASTNode } locals: #()
			body: (aZagTSNode >> 2) asZagASTNode body }
]

{ #category : 'converting' }
ZagTSTryConverter >> tryExceptToZagSwitch: aZagTSNode [
	^ASSend
		target: (aZagTSNode >> 1) asZagASTNode
		selector: #onErrorDo:
		args: { ASBlockNode arguments: { ASRef variable: self class exceptSwitchVariableName }
			locals: #()
			body: { ASSend target: (
				aZagTSNode children allButFirst collect: [ :c |
					self exceptToZagCase: c switchVariable: (ASRef variable: self class exceptSwitchVariableName)
				] as: ASArray) selector: #switch } }.
]

{ #category : 'converting' }
ZagTSTryConverter >> trySingleExceptToZagAST: aZagTSNode [
	"Converts a try with a single except to a Zag AST."
	(aZagTSNode >> 2) childrenCount > 1
		ifFalse: [ ^ASSend
			target: (aZagTSNode >> 1) asZagASTNode
			selector: #onErrorDo:
			args: { (aZagTSNode >> 2 >> 1) asZagASTNode } ]
		ifTrue: [ ^ASSend
			target: (aZagTSNode >> 1) asZagASTNode
			selector: #on:do:
			args: { (aZagTSNode >> 2 >> 1 >> 1) asZagASTNode.
				ASBlockNode
					arguments: { (aZagTSNode >> 2 >> 1 >> 2 >> 1) asZagASTNode } locals: #()
					body: (aZagTSNode >> 2 >> 2) asZagASTNode body } ]
]
