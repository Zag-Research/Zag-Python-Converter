"
I am a ZagSendConverter for if-elif-else statements
"
Class {
	#name : 'ZagIfElseConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagIfElseConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	self subclassesDo: [ :class | class putRules: aClass ]
]

{ #category : 'testing' }
ZagIfElseConverter class >> representsElse: switchKey [
	"Returns whether the provided switch key represents an else statement."
	switchKey ifNil: [ ^true ].
	switchKey == true ifTrue: [ ^true ].
	switchKey = (ASLiteral literal: true) ifTrue: [ ^true ].
	^false
]

{ #category : 'visiting' }
ZagIfElseConverter >> acceptExpression: condition if: ifValue else: elseValue asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	ifValue body size = 1 ifFalse: [ self notYetImplemented ].
	elseValue body size = 1 ifFalse: [ self notYetImplemented ].
	aVisitor visit: ifValue body first.
	aVisitor resultStream nextPutAll: ' if '.
	aVisitor visit: condition.
	aVisitor resultStream nextPutAll: ' else '.
	aVisitor visit: elseValue body first.
]

{ #category : 'visiting' }
ZagIfElseConverter >> acceptPart: anAssociation type: aSymbol asVisitor: aVisitor [
	"Visits one if/elif/else part of a statement."
	aVisitor resultStream nextPutAll: aSymbol asString.
	aSymbol = #else ifFalse: [
		aVisitor resultStream nextPut: Character space.
		aVisitor visit: anAssociation key.
	].
	aVisitor resultStream nextPut: $:; nextPut: Character cr.
	aVisitor addIndent: 1.
	aVisitor visitStatements: anAssociation value.
	aVisitor addIndent: -1.
	
]

{ #category : 'visiting' }
ZagIfElseConverter >> acceptStatement: aSwitch asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	| isFirst |
	isFirst := true.
	aSwitch do: [ :each | | symbol |
		"== true used because part key is usually not a boolean"
		symbol := (self class representsElse: each key)
			ifTrue: [ #else ]
			ifFalse: [ isFirst ifTrue: [ #if ] ifFalse: [ #elif ] ].
		self acceptPart: each type: symbol asVisitor: aVisitor.
		isFirst := false.
	]
]

{ #category : 'parsing' }
ZagIfElseConverter >> sendToSwitch: aSend [
	"Converts the provided ASSend to a list of associations."
	"Each association should map a condition AST to a block AST."
	self subclassResponsibility
]

{ #category : 'visiting' }
ZagIfElseConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	| switch |
	switch := self sendToSwitch: aSend.
	aVisitor inSubexpression ifTrue: [
		(switch size = 2 and: [ self class representsElse: switch last key ])
			ifFalse: [ ^self notYetImplemented ].
		self
			acceptExpression: switch first key
			if: switch first value
			else: switch last value
			asVisitor: aVisitor.
	] ifFalse: [ self acceptStatement: switch asVisitor: aVisitor ]
]
