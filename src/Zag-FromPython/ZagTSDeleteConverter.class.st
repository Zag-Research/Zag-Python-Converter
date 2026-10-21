"
I am the ZagTSConverter for the del statement.
"
Class {
	#name : 'ZagTSDeleteConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSDeleteConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #delete_statement putRule: self new
]

{ #category : 'constants' }
ZagTSDeleteConverter class >> subscriptToDeleteSelectorMap [
	^{
		#zwAt: -> #zwRemoveAt:.
		#zwCopyFrom:to: -> #zwRemoveFrom:to:.
		#zwCopyFrom:to:by: -> #zwRemoveFrom:to:by:. 
	} asDictionary
]

{ #category : 'converting' }
ZagTSDeleteConverter >> convertToZagAST: aZagTSNode [
	| subscriptAST |
	(aZagTSNode >> 1) tsNodeType = #subscript ifFalse: [ ^self notYetImplemented ].
	subscriptAST := ZagTSSubscriptConverter new convertToZagAST: aZagTSNode >> 1.
	subscriptAST selector: (self class subscriptToDeleteSelectorMap at: subscriptAST selector).
	^subscriptAST
]
