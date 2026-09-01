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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> outputCall: selector args: args [
	"Prints a function call to my stream."
	resultStream nextPutAll: selector asString; nextPut: $(.
	self visit: args first.
	args allButFirstDo: [ :arg |
		resultStream nextPutAll: ', '.
		self visit: arg.
	].
	resultStream nextPut: $).
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> outputFormattedIfElse: switchASTMap [
	"Outputs an if/else statement based on the provided AST."
	"It should be a collection made of associations, as in Zag-FromPython's switch statement."
	"Use the literal true (not an ASLiteral) as the key to specify the else statement."
	| isFirst |
	isFirst := true.
	switchASTMap do: [ :part |
		(part key == true or: [ part key = (ASLiteral literal: true)]) "== true used because part key is usually not a boolean"
			ifTrue: [ self resultStream nextPutAll: 'else:
' ]
			ifFalse: [
				self resultStream nextPutAll: (isFirst ifTrue: ['if '] ifFalse: ['elif ']).
				self visit: part key.
				self resultStream nextPutAll: ':
'
			].
		self addIndent: 1.
		self visitStatements: part value.
		self addIndent: -1.
		isFirst := false.
	].
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitArrayAccess: arrayTree index: index isZeroIndexed: isZeroIndexed [
	"Translates an array access operation to a subscript."
	self visit: arrayTree.
	resultStream nextPut: $[.
	self visit: index.
	isZeroIndexed ifFalse: [ resultStream nextPutAll: ' - 1' ].
	resultStream nextPut: $].
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitArraySet: arrayTree index: index value: value isZeroIndexed: isZeroIndexed [
	"Translates an array access operation to a subscript."
	self visitArrayAccess: arrayTree index: index isZeroIndexed: isZeroIndexed.
	resultStream nextPutAll: ' = '.
	self visit: value.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitAssign: anAssign [
	"Visits an ASAssign, adding its associated Python source to my stream."
	self visit: anAssign variable.
	resultStream nextPutAll: ' = '.
	self visit: anAssign expression.
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitDatatypeConversion: aSend [
	"Prints a datatype conversion to my stream."
	| pythonSelector |
	pythonSelector := self class smalltalkToPythonDatatypeConversions at: aSend selector.
	self outputCall: pythonSelector args: { aSend target }.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitForEach: aSend [
	"Visits and outputs a do: send as a for-in loop."
	self resultStream nextPutAll: 'for '.
	self visitRef: aSend args first arguments first.
	self resultStream nextPutAll: ' in '.
	self visit: aSend target.
	self resultStream nextPut: $:; nextPut: Character cr.
	self addIndent: 1.
	self visitStatements: aSend args first.
	self addIndent: -1.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitIfElse: aSend [
	"Prepares aSend for outputFormattedIfElse: and outputs it."
	aSend selector = #ifTrue: ifTrue: [ ^self outputFormattedIfElse: { aSend target -> aSend args first } ].
	aSend selector = #ifFalse: ifTrue: [ ^self outputFormattedIfElse: {
		aSend target -> nil. true -> aSend args first.
	} ].
	aSend selector = #ifFalse:ifTrue: ifTrue: [ ^self outputFormattedIfElse: { 
		aSend target -> aSend args last. true -> aSend args first.
	} ].
	aSend selector = #ifTrue:ifFalse: ifTrue: [ ^self outputFormattedIfElse: { 
		aSend target -> aSend args first. true -> aSend args last.
	} ].
	aSend selector = #switch ifTrue: [ ^self outputFormattedIfElse: (
		aSend target statements collect: [ :each | each selector = #->
			ifTrue: [ each target -> each args first ]
			ifFalse: [ self error: 'Invalid selector for switch statement part.' ] ]
	) ].
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

{ #category : 'visiting' }
ZagToPythonVisitor >> visitMethod: aMethod [
	"Outputs a method to the result."
	aMethod selector = self class mainMethodSelector ifTrue: [
		^self visitStatements: aMethod
	].
	self shouldBeImplemented.
	
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitRange: aSend exclusive: exclusive [
	| hasStep |
	hasStep := aSend selector asString includesSubstring: 'by:'.
	self resultStream nextPutAll: 'range('.
	self visit: aSend target.
	self resultStream nextPutAll: ', '.
	exclusive ifFalse: [ self resultStream nextPut: $( ].
	self visit: aSend args first.
	exclusive ifFalse: [ self resultStream nextPutAll: ') + 1' ].
	hasStep ifTrue: [
		self resultStream nextPutAll: ', '.
		self visit: aSend args last.
	].
	self resultStream nextPut: $).
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
	(#(#ifTrue: #ifFalse: #ifFalse:ifTrue: #ifTrue:ifFalse: #switch) includes: aSend selector) ifTrue:
		[ ^self visitIfElse: aSend ].
	(#(#to: #to:by:) includes: aSend selector) ifTrue: [ ^self visitRange: aSend exclusive: false ].
	(#(#toExclusive: #toExclusive:by:) includes: aSend selector) ifTrue: [ ^self visitRange: aSend exclusive: true ].
	(aSend selector = #do:) ifTrue: [ ^self visitForEach: aSend ].
	(aSend selector = #whileTrue:) ifTrue: [ ^self visitWhile: aSend ].
	(aSend selector = #whileFalse:) ifTrue: [ ^self visitWhile: (
		ASSend target: aSend target negateLastStatement selector: aSend selector args: aSend args) ].
	(aSend selector = #i and: [ aSend target isASLiteral ]) ifTrue: [
		self visitLiteral: aSend target.
		^self resultStream nextPut: $j.
	].
	self error: 'Unrecognized selector'
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitStatements: aCollectionOrNil [
	"Outputs the statements in aCollection, calling their accept: method."
	"The argument can be nil, in which case 'pass' will be outputted."
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
			statements do: [ :each |
				self withIndentAndNewline: [ self visit: each ]
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitWhile: aSend [
	"Translate a while loop to Python."
	aSend target isASBlock ifFalse: [ self error: 'While condition must be a block.' ].
	aSend target body size = 1 ifFalse: [ self notYetImplemented ].
	self resultStream nextPutAll: 'while '.
	self visit: aSend target body first.
	self resultStream nextPut: $:; nextPut: Character cr.
	self addIndent: 1.
	self visitStatements: aSend args first.
	self addIndent: -1.
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
