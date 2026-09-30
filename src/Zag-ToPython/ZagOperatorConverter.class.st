"
I am the ZagSendConverter for sends that convert to Python operators.
"
Class {
	#name : 'ZagOperatorConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'pythonSelector'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'constants' }
ZagOperatorConverter class >> argumentCount [
	"Returns how many arguments operators of this class has, **excluding the target**"
	self subclassResponsibility
]

{ #category : 'testing' }
ZagOperatorConverter class >> needsBrackets: anObject forChild: itsChild isTarget: isTarget [
	"Determines whether I need to place brackets around an object's child."
	| parentPrecedence childPrecedence |
	(itsChild isKindOf: ASStatement) ifFalse: [ ^true ].
	(itsChild isKindOf: ASAssign) ifTrue: [ ^true ].
	itsChild isASLiteral ifTrue: [ ^false ].
	itsChild isASRef ifTrue: [ ^false ].
	parentPrecedence := self pythonPrecedence: anObject.
	childPrecedence := self pythonPrecedence: itsChild.
	^isTarget
		ifTrue: [ parentPrecedence > childPrecedence ]
		ifFalse: [ parentPrecedence >= childPrecedence ].
]

{ #category : 'constants' }
ZagOperatorConverter class >> precedenceMap [
	"Returns a map mapping Python operators to their precedence."
	"Some operators, e.g. -, have both unary and binary versions,"
	"so this needs to be implemented in the subclasses."
	self subclassResponsibility
]

{ #category : 'setting' }
ZagOperatorConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	self subclassesDo: [ :class | class putRules: aClass ]
]

{ #category : 'accessing' }
ZagOperatorConverter class >> pythonPrecedence: aSend [
	"Gets the predence of the provided send operator."
	"using ZagOperatorConverter instead of self because"
	"unary & binary operators should be able to get precedence of each other"
	^ZagOperatorConverter subclasses
		detect: [ :converter | converter argumentCount = aSend args size ]
		ifFound: [ :converter | converter precedenceMap at: (converter selectorMap at: aSend selector) ]
		ifNone: [ self error: 'Could not find any class for this kind of operator.' ]
		
	
]

{ #category : 'constants' }
ZagOperatorConverter class >> selectorMap [
	"Returns a dictionary mapping Smalltalk selectors to Python operators."
	self subclassResponsibility
]

{ #category : 'accessing' }
ZagOperatorConverter >> pythonSelector [

	^ pythonSelector
]

{ #category : 'accessing' }
ZagOperatorConverter >> pythonSelector: aSymbol [

	pythonSelector := aSymbol
]
