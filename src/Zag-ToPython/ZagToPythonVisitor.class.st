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
ZagToPythonVisitor class >> isInput: aSend [
	"Tests if a send should be translated to an input() statement."
	| targetValid |
	aSend isASSend ifFalse: [ ^false ].
	targetValid := aSend target isASSend and: [ aSend target target = UIManager and:
			[ aSend target selector = #default ] ].
	^targetValid and: [ aSend selector = #request: ].
]

{ #category : 'testing' }
ZagToPythonVisitor class >> isPrint: aCascade [
	"Tests if an ASCascade should be translated to a print statement."
	| targetMatches twoSends firstMatches secondMatches |
	targetMatches := aCascade target = Transcript.
	twoSends := aCascade sends size = 2.
	firstMatches := aCascade sends first selector = #show:.
	secondMatches := aCascade sends last selector = #cr.
	^targetMatches & twoSends & firstMatches & secondMatches.
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
ZagToPythonVisitor class >> smalltalkToPythonDatatypeConversions [
	"A dictionary mapping datatype conversions."
	"Always maps 'a m1' to 'm2(a)', where m1 -> m2 is an element here"
	^{
		#asInteger -> #int.
		#asNumber -> #float.
		#asString -> #str.
	} asDictionary
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> outputCall: selector args: args [
	"Prints a function call to my stream."
	resultStream nextPutAll: selector asString; nextPut: $(.
	args first accept: self.
	args allButFirstDo: [ :arg |
		resultStream nextPutAll: ', '.
		arg accept: self.
	].
	resultStream nextPut: $).
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitArrayAccess: arrayTree index: index isZeroIndexed: isZeroIndexed [
	"Translates an array access operation to a subscript."
	arrayTree accept: self.
	resultStream nextPut: $[.
	index accept: self.
	isZeroIndexed ifFalse: [ resultStream nextPutAll: ' - 1' ].
	resultStream nextPut: $].
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitArraySet: arrayTree index: index value: value isZeroIndexed: isZeroIndexed [
	"Translates an array access operation to a subscript."
	self visitArrayAccess: arrayTree index: index isZeroIndexed: isZeroIndexed.
	resultStream nextPutAll: ' = '.
	value accept: self.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitAssign: anAssign [
	"Visits an ASAssign, adding its associated Python source to my stream."
	self visit: anAssign variable.
	resultStream nextPutAll: ' = '.
	self visit: anAssign expression.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitCascade: aCascade [
	"Visits an ASCascade, adding its associated Python source to my stream."
	(self class isPrint: aCascade) ifTrue: [ ^self outputCall: #print args: { aCascade sends first args first } ].
	aCascade sends collect: [ :send | send target: aCascade target ] thenDo: [ :each | self visit: each ]
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitDatatypeConversion: aSend [
	"Prints a datatype conversion to my stream."
	| pythonSelector |
	pythonSelector := self class smalltalkToPythonDatatypeConversions at: aSend selector.
	self outputCall: pythonSelector args: { aSend target }.
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
	(self class smalltalkToPythonOperations includesKey: aSend selector) ifTrue:
		[ ^self visitOperation: aSend ].
	(self class smalltalkToPythonDatatypeConversions includesKey: aSend selector) ifTrue:
		[ ^self visitDatatypeConversion: aSend ].
	(self class isInput: aSend) ifTrue: [ ^self outputCall: #input args: { aSend args first } ].
	(aSend selector = #at:) ifTrue:
		[ ^self visitArrayAccess: aSend target index: aSend args first isZeroIndexed: false ].
	(aSend selector = #zwAt:) ifTrue:
		[ ^self visitArrayAccess: aSend target index: aSend args first isZeroIndexed: true ].
	(aSend selector = #at:put:) ifTrue:
		[ ^self visitArraySet: aSend target index: aSend args first value: aSend args last isZeroIndexed: false ].
	(aSend selector = #zwAt:put:) ifTrue:
		[ ^self visitArraySet: aSend target index: aSend args first value: aSend args last isZeroIndexed: true ].
	self error: 'Unrecognized selector'
]
