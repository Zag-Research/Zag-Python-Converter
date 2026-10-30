"
A Zag converter for the onErrorDo: message.
"
Class {
	#name : 'ZagOnErrorDoConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'hasAs'
	],
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'testing' }
ZagOnErrorDoConverter class >> canConvertToMultipleExcept: aBlock [
	"Accepts the argument of an onErrorDo: send, and determines if it can be converted to multiple excepts."
	aBlock isASBlock ifFalse: [ ^false ].
	aBlock body size = 1 ifFalse: [ ^false ].
	aBlock body first isASSend ifFalse: [ ^false ].
	aBlock body first selector = #switch ifFalse: [ ^false ].
	^aBlock body first target statements
		allSatisfy: [ :statement | self isExceptSwitchClause: statement ].
]

{ #category : 'testing' }
ZagOnErrorDoConverter class >> isExceptSwitchClause: aSend [
	"Returns true if a Zag AST can be translated to an except clause, as part of an except switch."
	aSend isASSend ifFalse: [ ^false ].
	aSend selector = #-> ifFalse: [ ^false ].
	aSend target isASSend ifFalse: [ ^false ].
	^aSend target selector = #isKindOf:
	
]

{ #category : 'setting' }
ZagOnErrorDoConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #onErrorDo: putRule: (self new hasAs: false; yourself).
	aClass at: #on:do: putRule: (self new hasAs: true; yourself).
]

{ #category : 'accessing' }
ZagOnErrorDoConverter >> hasAs [

	^ hasAs
]

{ #category : 'accessing' }
ZagOnErrorDoConverter >> hasAs: anObject [

	hasAs := anObject
]

{ #category : 'visiting' }
ZagOnErrorDoConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'try:'; nextPut: Character cr.
	aVisitor addIndent: 1; visitStatements: aSend target; addIndent: -1.
	self hasAs ifTrue: [
		self
			visitExceptType: aSend args first
			name: aSend args second arguments first
			body: aSend args second
			asVisitor: aVisitor
	] ifFalse: [
		(self class canConvertToMultipleExcept: aSend args first )
			ifTrue: [ self visitMultiExcept: aSend args first asVisitor: aVisitor ]
			ifFalse: [ self visitExceptType: nil name: nil body: aSend args first asVisitor: aVisitor ]
	]
]

{ #category : 'visiting' }
ZagOnErrorDoConverter >> visitExceptType: typeRef name: nameRef body: statements asVisitor: aVisitor [
	aVisitor resultStream nextPutAll: 'except'.
	typeRef ifNotNil: [
		aVisitor resultStream nextPut: Character space.
		aVisitor visit: typeRef.
		nameRef ifNotNil: [
			aVisitor resultStream nextPutAll: ' as '.
			aVisitor visit: nameRef.
		].
	].
	aVisitor resultStream nextPut: $:; nextPut: Character cr.
	aVisitor addIndent: 1; visitStatements: statements; addIndent: -1.
]

{ #category : 'visiting' }
ZagOnErrorDoConverter >> visitMultiExcept: aBlock asVisitor: aVisitor [
	aBlock body first target statements do: [ :statement | 
		self
			visitExceptType: statement target args first
			name: statement args first arguments first
			body: statement args first
			asVisitor: aVisitor
	]
]
