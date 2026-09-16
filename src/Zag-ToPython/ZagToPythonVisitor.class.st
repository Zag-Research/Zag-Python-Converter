"
I am a visitor that can be used to convert Zag ASTs into Python source code.
"
Class {
	#name : 'ZagToPythonVisitor',
	#superclass : 'Object',
	#instVars : [
		'resultStream',
		'indentLevel',
		'nestingLevel'
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
	targetValid := (aSend target isKindOf: ASSend) and: [ aSend target target = (ASRef variable: #UIManager) and:
			[ aSend target selector = #default ] ].
	^targetValid and: [ aSend selector = #request: ].
]

{ #category : 'testing' }
ZagToPythonVisitor class >> isPrint: aCascade [
	"Tests if an ASCascade should be translated to a print statement."
	| targetMatches twoSends firstMatches secondMatches |
	targetMatches := aCascade target = (ASRef variable: #Transcript).
	twoSends := aCascade sends size = 2.
	firstMatches := aCascade sends first selector = #show:.
	secondMatches := aCascade sends last selector = #cr.
	^targetMatches & twoSends & firstMatches & secondMatches.
]

{ #category : 'constants' }
ZagToPythonVisitor class >> mainMethodSelector [
	"The selector used for the main method, where non-method code is put in."
	^#main.
]

{ #category : 'testing' }
ZagToPythonVisitor class >> needsBrackets: anObject forChild: itsChild isTarget: isTarget [
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

{ #category : 'instance creation' }
ZagToPythonVisitor class >> new [
	^self basicNew indentLevel: 0; nestingLevel: 0; yourself.
]

{ #category : 'constants' }
ZagToPythonVisitor class >> pythonBinaryOperatorPrecedence [
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

{ #category : 'accessing' }
ZagToPythonVisitor class >> pythonPrecedence: aSend [
	"Gets the predence of the provided send operator."
	aSend args isEmpty
		ifTrue: [ ^self pythonUnaryOperatorPrecedence at: (
			self smalltalkToPythonUnaryOperations at: aSend selector) ]
		ifFalse: [ ^self pythonBinaryOperatorPrecedence at: (
			self smalltalkToPythonBinaryOperations at: aSend selector) ]
	
]

{ #category : 'constants' }
ZagToPythonVisitor class >> pythonUnaryOperatorPrecedence [
	"A dictionary mapping unary Python operators to their precedence."
	"source: https://www.w3schools.com/python/python_operators_precedence.asp"
	^{
		#+ -> 10. #- -> 10. #~ -> 10.
		#not -> 2.
	} asDictionary.
]

{ #category : 'constants' }
ZagToPythonVisitor class >> smalltalkToPythonBinaryOperations [
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

{ #category : 'constants' }
ZagToPythonVisitor class >> smalltalkToPythonUnaryOperations [
	"Returns a dictionary mapping unary Smalltalk operands to Python."
	^{ 
		#not -> #not.
		#pythonNot -> #not.
		#negated -> #-.
		#bitInvert -> #~.
	} asDictionary.
]

{ #category : 'setting' }
ZagToPythonVisitor >> addIndent: anInteger [
	"Changes my indent level by the amount provided."
	"The argument can be a negative integer to reduce indent."
	indentLevel := indentLevel + anInteger.
]

{ #category : 'setting' }
ZagToPythonVisitor >> addNesting: anInteger [
	"Changes my nesting level by the amount provided."
	"The argument can be a negative integer to reduce nesting."
	nestingLevel := nestingLevel + anInteger.
]

{ #category : 'accessing' }
ZagToPythonVisitor >> inSubexpression [
	"Returns true iff I am currently visiting a subexpression, like the bracketed part of a := (b := c)."
	^self nestingLevel > 1
]

{ #category : 'accessing' }
ZagToPythonVisitor >> indentLevel [
	"The current indent level for my outputted Python code."
	"A non-negative integer referring to the number of tab characters I will output before each line."
	^indentLevel
]

{ #category : 'setting' }
ZagToPythonVisitor >> indentLevel: anInteger [
	"Sets my current indent level."
	indentLevel := anInteger.
]

{ #category : 'accessing' }
ZagToPythonVisitor >> nestingLevel [
	"The current nesting level for my outputted Python code."
	^nestingLevel
]

{ #category : 'setting' }
ZagToPythonVisitor >> nestingLevel: anInteger [
	"Sets my current nesting level."
	nestingLevel := anInteger.
]

{ #category : 'printing helpers' }
ZagToPythonVisitor >> outputCall: selector args: args [
	"Prints a function call to my stream."
	self resultStream nextPutAll: selector asString.
	self outputCollection: args begin: '(' end: ')' separator: ', '.
]

{ #category : 'printing helpers' }
ZagToPythonVisitor >> outputCollection: aCollection begin: startDelimiter end: endDelimiter separator: separator [
	"Output a collection to the standard output.  The start, end and separator can be customized.  All should be strings."
	self resultStream nextPutAll: startDelimiter.
	aCollection
		do: [ :each | self visit: each ]
		separatedBy: [ self resultStream nextPutAll: separator ].
	self resultStream nextPutAll: endDelimiter.
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
	| returnValue |
	self addNesting: 1.
	returnValue := anAST accept: self.
	self addNesting: -1.
	^returnValue.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visit: anObject withBrackets: enableBrackets [
	"Prints an object, maybe with brackets around it."
	enableBrackets ifTrue: [ resultStream nextPut: $( ].
	self visit: anObject.
	enableBrackets ifTrue: [ resultStream nextPut: $) ].
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitArray: anArray [
	self outputCollection: anArray statements begin: '[' end: ']' separator: ', '
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitAssign: anAssign [
	"Visits an ASAssign, adding its associated Python source to my stream."
	self visit: anAssign variable.
	resultStream nextPutAll: (self nestingLevel > 1 ifTrue: [' := '] ifFalse: [' = ']).
	self visit: anAssign expression withBrackets: anAssign expression isASAssign.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitBinaryOperation: aSend [
	"Like visitSend, but the selector is in smalltalkToPythonBinaryOperations."
	| arg |
	self visit: aSend target withBrackets: (
		self class needsBrackets: aSend forChild: aSend target isTarget: true).
	resultStream nextPut: Character space.
	resultStream nextPutAll: (self class smalltalkToPythonBinaryOperations at: aSend selector).
	resultStream nextPut: Character space.
	arg := aSend args first isASBlock
		ifTrue: [ aSend args first body last ]
		ifFalse: [ aSend args first ].
	self visit: arg withBrackets: (
		self class needsBrackets: aSend forChild: arg isTarget: false).
	
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitCascade: aCascade [
	"Visits an ASCascade, adding its associated Python source to my stream."
	(self class isPrint: aCascade) ifTrue: [ ^self outputCall: #print args: { aCascade sends first args first } ].
	aCascade sends collect: [ :send | send target: aCascade target ] thenDo: [ :each | self visit: each ]
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitLiteral: aLiteral [
	"Visits an ASLiteral, adding its associated Python source to my stream."
	{ 
		aLiteral literal isString -> [
			resultStream nextPut: $".
			resultStream nextPutAll: aLiteral literal.
			resultStream nextPut: $".
		].
		aLiteral literal isCollection -> [ | literals |
			literals := aLiteral literal collect: [ :each | ASLiteral literal: each ].
			self visitArray: (ASArray statements: literals)
		].
		aLiteral literal isNil -> [ resultStream nextPutAll: 'None' ].
		"using == true/false as the literal can be any type"
		aLiteral literal == true -> [ resultStream nextPutAll: 'True' ].
		aLiteral literal == false -> [ resultStream nextPutAll: 'False' ].
		true -> [ resultStream nextPutAll: aLiteral literal asString ]
	} switch
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitMethod: aMethod [
	"Outputs a method to the result."
	aMethod selector = self class mainMethodSelector ifTrue: [
		^self visitStatements: aMethod
	].
	self shouldBeImplemented.
	
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
	(self class smalltalkToPythonBinaryOperations includesKey: aSend selector) ifTrue:
		[ ^self visitBinaryOperation: aSend ].
	(self class smalltalkToPythonUnaryOperations includesKey: aSend selector) ifTrue:
		[ ^self visitUnaryOperation: aSend ].
	(self class isInput: aSend) ifTrue: [ ^self outputCall: #input args: { aSend args first } ].
	ZagSendConverter accept: aSend asVisitor: self.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitStatements: aCollectionOrNil [
	"Outputs the statements in aCollection, calling their accept: method."
	"The argument can be nil or empty, in which case 'pass' will be outputted."
	"The argument can also be a method/block node, in which its body will be visited."
	| oldNestingLevel |
	oldNestingLevel := self nestingLevel.
	self nestingLevel: 0.
	aCollectionOrNil
		ifNil: [ self withIndentAndNewline: [ self resultStream nextPutAll: 'pass' ] ]
		ifNotNil: [ | statements |
			statements := (aCollectionOrNil respondsTo: #body)
				ifTrue: [ aCollectionOrNil body ]
				ifFalse: [ aCollectionOrNil ].
			statements
				ifEmpty: [ self withIndentAndNewline: [ self resultStream nextPutAll: 'pass' ] ]
				ifNotEmpty: [ statements do: [ :each |
					self withIndentAndNewline: [ self visit: each ] ].
		] ].
	self nestingLevel: oldNestingLevel.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitUnaryOperation: aSend [
	"Like visitSend, but the selector is in smalltalkToPythonUnaryOperations."
	resultStream nextPutAll: (self class smalltalkToPythonUnaryOperations at: aSend selector).
	aSend selector = #not ifTrue: [ self resultStream nextPut: Character space ].
	self visit: aSend target withBrackets: (
		self class needsBrackets: aSend forChild: aSend target isTarget: true).
	
]

{ #category : 'visiting' }
ZagToPythonVisitor >> withIndentAndNewline: aBlock [
	"Indents, then runs aBlock, then outputs a newline."
	self indentLevel timesRepeat: [
			resultStream nextPut: Character tab.
	].
	aBlock value.
	resultStream nextPut: Character cr.
]
