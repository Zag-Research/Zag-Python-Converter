"
I am a visitor that can be used to convert Zag ASTs into Python source code.
"
Class {
	#name : 'ZagToPythonVisitor',
	#superclass : 'Object',
	#instVars : [
		'resultStream'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'converting' }
ZagToPythonVisitor class >> astToPythonSource: anAST [
	"Convert a Zag AST to Python source code."
	^String streamContents: [ :stream | self new resultStream: stream; visit: anAST ]
]

{ #category : 'testing' }
ZagToPythonVisitor class >> needsBrackets: anObject forChild: itsChild isTarget: isTarget [
	"Determines whether I need to place brackets around an object's child."
	| parentPrecedence childPrecedence |
	(itsChild isKindOf: ASStatement) ifFalse: [ ^true ].
	itsChild isASLiteral ifTrue: [ ^false ].
	parentPrecedence := self pythonOperatorPrecedence at: anObject selector.
	childPrecedence := self pythonOperatorPrecedence at: itsChild selector.
	^isTarget
		ifTrue: [ parentPrecedence > childPrecedence ]
		ifFalse: [ parentPrecedence >= childPrecedence ].
]

{ #category : 'constants' }
ZagToPythonVisitor class >> pythonOperatorPrecedence [
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

{ #category : 'constants' }
ZagToPythonVisitor class >> smalltalkToPythonOperations [
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
		#>= -> #>-.
		#raisedTo: -> #**.
		#bitXor: -> #'^'.
		#bitShift: -> #<<.
		#= -> #==.
		#~= -> #!=.
		#== -> #is.
		#~~ -> #'is not'
	} asDictionary.
]

{ #category : 'accessing' }
ZagToPythonVisitor >> resultStream [
	"Gets my result stream."
	^resultStream
]

{ #category : 'setting' }
ZagToPythonVisitor >> resultStream: aStream [
	"Sets my result stream."
	resultStream := aStream
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visit: anAST [
	"Accepts an AST, and prints its corresponding Python source to my result stream."
	^anAST accept: self
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visit: anObject withBrackets: enableBrackets [
	"Prints an object, maybe with brackets around it."
	enableBrackets ifTrue: [ resultStream nextPut: $( ].
	anObject accept: self.
	enableBrackets ifTrue: [ resultStream nextPut: $) ].
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitAssign: anAssign [
	"Visits an ASAssign, adding its associated Python source to my stream."
	self visit: anAssign variable.
	resultStream nextPutAll: ' = '.
	self visit: anAssign expression.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitCascade: aCascade [
	"Visits an ASCascade, adding its associated Python source to my stream."
	aCascade collect: [ :send | send target: aCascade target ] thenDo: [ :each | self visit: each ]
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitLiteral: aLiteral [
	"Visits an ASLiteral, adding its associated Python source to my stream."
	aLiteral literal isString
		ifTrue: [
			resultStream nextPut: $".
			resultStream nextPutAll: aLiteral literal.
			resultStream nextPut: $".
		] ifFalse: [ resultStream nextPutAll: aLiteral literal asString ]
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitOperation: aSend [
	"Like visitSend, but the selector is in smalltalkToPythonOperations."
	self visit: aSend target withBrackets: (
		self class needsBrackets: aSend forChild: aSend target isTarget: true).
	resultStream nextPut: Character space.
	resultStream nextPutAll: (self class smalltalkToPythonOperations at: aSend selector).
	resultStream nextPut: Character space.
	self visit: aSend args first withBrackets: (
		self class needsBrackets: aSend forChild: aSend args first isTarget: false).
	
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitRef: aRef [
	"Visits an ASRef, adding its associated Python source to my stream."
	resultStream nextPutAll: aRef variable asString
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitReturn: aReturn [
	"Visits an ASReturn, adding its associated Python source to my stream."
	resultStream nextPutAll: 'return '.
	self visit: aReturn expression.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitSend: aSend [
	"Prints a send operation to my stream."
	{
		[ self class smalltalkToPythonOperations includesKey: aSend selector ] -> [ self visitOperation: aSend ].
	} switch.
]
