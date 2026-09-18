"
I am the ZagSendConverter for unary operations.

My `#pythonSelector` variable contains the selector that will be used in Python.
"
Class {
	#name : 'ZagUnaryOperatorConverter',
	#superclass : 'ZagOperatorConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'constants' }
ZagUnaryOperatorConverter class >> argumentCount [
	"Returns how many arguments operators of this class has, **excluding the target**"
	^0
]

{ #category : 'constants' }
ZagUnaryOperatorConverter class >> precedenceMap [
	"A dictionary mapping unary Python operators to their precedence."
	"source: https://www.w3schools.com/python/python_operators_precedence.asp"
	^{
		#+ -> 10. #- -> 10. #~ -> 10.
		#not -> 2.
	} asDictionary.
]

{ #category : 'setting' }
ZagUnaryOperatorConverter class >> putRules: aClass [
	self selectorMap keysAndValuesDo: [ :stSelector :pySelector |
		aClass at: stSelector putRule: (self new pythonSelector: pySelector).
	]
]

{ #category : 'constants' }
ZagUnaryOperatorConverter class >> selectorMap [
	"Returns a dictionary mapping unary Smalltalk operands to Python."
	^{ 
		#not -> #not.
		#pythonNot -> #not.
		#negated -> #-.
		#bitInvert -> #~.
	} asDictionary.
]

{ #category : 'visiting' }
ZagUnaryOperatorConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: self pythonSelector asString.
	aSend selector = #not ifTrue: [ aVisitor resultStream nextPut: Character space ].
	aVisitor visit: aSend target withBrackets: (
		self class needsBrackets: aSend forChild: aSend target isTarget: true).
]
