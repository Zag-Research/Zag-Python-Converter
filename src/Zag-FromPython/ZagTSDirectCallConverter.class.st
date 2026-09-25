"
I am the ZagTSBuiltinConverter that simply copies the Python arguments into Zag in the same order.  My instance variable #zagSelector is the Zag selector.
"
Class {
	#name : 'ZagTSDirectCallConverter',
	#superclass : 'ZagTSBuiltinConverter',
	#instVars : [
		'zagSelector'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSDirectCallConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	{ #int -> #asInteger. #float -> #asNumber. #str -> #asString. #set -> #asSet } asDictionary
		keysAndValuesDo: [ :k :v | aClass at: k putBuiltinRule: (self new zagSelector: v) ].
]

{ #category : 'converting' }
ZagTSDirectCallConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	^ASSend
		target: (aBuiltin >> 2 >> 1) asZagASTNode
		selector: self zagSelector
]

{ #category : 'accessing' }
ZagTSDirectCallConverter >> zagSelector [

	^ zagSelector
]

{ #category : 'accessing' }
ZagTSDirectCallConverter >> zagSelector: anObject [

	zagSelector := anObject
]
