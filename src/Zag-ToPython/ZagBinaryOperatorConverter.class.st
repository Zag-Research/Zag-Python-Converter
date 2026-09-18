"
I am the ZagSendConverter for binary operations.

My `#pythonSelector` variable contains the selector that will be used in Python.
"
Class {
	#name : 'ZagBinaryOperatorConverter',
	#superclass : 'ZagOperatorConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'constants' }
ZagBinaryOperatorConverter class >> argumentCount [
	^1
]

{ #category : 'constants' }
ZagBinaryOperatorConverter class >> precedenceMap [
	"A dictionary mapping binary Python operators to their precedence."
	"source: https://www.w3schools.com/python/python_operators_precedence.asp"
	^{
		#** -> 11.
		#* -> 9. #/ -> 9. #// -> 9. #% -> 9.
		#+ -> 8. #- -> 8.
		#<< -> 7. #>> -> 7.
		#& -> 6.
		#'^' -> 5.
		#| -> 4.
		#== -> 3. #!= -> 3. #> -> 3. #>= -> 3. #< -> 3. #<= -> 3.
		#is -> 3. #'is not' -> 3. #in -> 3. #'not in' -> 3.
		#and -> 1.
		#or -> 0.
	} asDictionary.
]

{ #category : 'setting' }
ZagBinaryOperatorConverter class >> putRules: aClass [
	self selectorMap keysAndValuesDo: [ :stSelector :pySelector |
		aClass at: stSelector putRule: (self new pythonSelector: pySelector)
	]
]

{ #category : 'constants' }
ZagBinaryOperatorConverter class >> selectorMap [
	"Returns a dictionary mapping Smalltalk operands to Python."
	^{ 
		#+ -> #+.
		#- -> #-.
		#* -> #*.
		#/ -> #/.
		#// -> #//.
		#% -> #%.
		#& -> #&.
		#| -> #|.
		#< -> #<.
		#<= -> #<=.
		#> -> #>.
		#>= -> #>=.
		#raisedTo: -> #**.
		#bitXor: -> #'^'.
		#bitShift: -> #<<.
		#= -> #==.
		#~= -> #!=.
		#== -> #is.
		#~~ -> #'is not'.
		#and: -> #and.
		#pythonAnd: -> #and.
		#or: -> #or.
		#pythonOr: -> #or.
	} asDictionary.
]

{ #category : 'visiting' }
ZagBinaryOperatorConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	| arg |
	aVisitor visit: aSend target withBrackets: (
		self class needsBrackets: aSend forChild: aSend target isTarget: true).
	aVisitor resultStream nextPut: Character space.
	aVisitor resultStream nextPutAll: self pythonSelector.
	aVisitor resultStream nextPut: Character space.
	arg := aSend args first isASBlock
		ifTrue: [ aSend args first body last ]
		ifFalse: [ aSend args first ].
	aVisitor visit: arg withBrackets: (
		self class needsBrackets: aSend forChild: arg isTarget: false).
]
