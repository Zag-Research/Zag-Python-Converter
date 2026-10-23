"
A ZagSendConverter for the array accesses at: and zwAt:
"
Class {
	#name : 'ZagArrayAccessConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'isZeroIndexed'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'testing' }
ZagArrayAccessConverter class >> includesSplat: aZagAST [
	"Returns true if the provided AST is an ASCascade that needs to be converted to a multi-access with a splat expression."
	(aZagAST isKindOf: ASCascade) ifFalse: [ ^false ].
	aZagAST target = (ASSend target: (ASRef variable: #OrderedCollection) selector: #new) ifFalse: [ ^false ].
	^aZagAST sends allSatisfy: [ :send | #(#add: #addAll: #yourself) includes: send selector ].
]

{ #category : 'constants' }
ZagArrayAccessConverter class >> intervalSelectors [
	"A set of selectors that create intervals, which should create slices if they are an access's argument."
	^#(#to: #to:by: #toExclusive: #toExclusive:by:) asSet
]

{ #category : 'setting' }
ZagArrayAccessConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #at: putRule: (self new isZeroIndexed: false).
	aClass at: #zwAt: putRule: (self new isZeroIndexed: true).
]

{ #category : 'instance creation' }
ZagArrayAccessConverter >> intervalConverter: aSend [
	| converter |
	converter := ZagArrayAccessIntervalTargetConverter new.
	converter isZeroIndexed: self isZeroIndexed.
	aSend selector = #to: ifTrue: [ ^converter isExclusive: false; hasStep: false; yourself ].
	aSend selector = #to:by: ifTrue: [ ^converter isExclusive: false; hasStep: true; yourself ].
	aSend selector = #toExclusive: ifTrue: [ ^converter isExclusive: true; hasStep: false; yourself ].
	aSend selector = #toExclusive:by: ifTrue: [ ^converter isExclusive: true; hasStep: true; yourself ].
	self error: 'Unrecognized selector'
]

{ #category : 'accessing' }
ZagArrayAccessConverter >> isZeroIndexed [

	^ isZeroIndexed
]

{ #category : 'accessing' }
ZagArrayAccessConverter >> isZeroIndexed: aBoolean [
	isZeroIndexed := aBoolean
]

{ #category : 'visiting' }
ZagArrayAccessConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor visit: aSend target.
	aVisitor resultStream nextPut: $[.
	(aSend args first isKindOf: ASArray) ifTrue: [ "using isKindOf: because isASArray doesn't exist"
		aSend args first statements
			do: [ :statement | self visitInterior: statement asVisitor: aVisitor ]
			separatedBy: [ aVisitor resultStream nextPutAll: ', ' ].
		aSend args first statements size = 1 ifTrue: [ aVisitor resultStream nextPut: $, ].
	] ifFalse: [
		(self class includesSplat: aSend args first)
			ifTrue: [ aSend args first sends allButLast
				do: [ :send | self visitSplatCascadePart: send asVisitor: aVisitor ]
				separatedBy: [ aVisitor resultStream nextPutAll: ', ' ].
				aSend args first sends size = 2 ifTrue: [ aVisitor resultStream nextPut: $, ].
			] ifFalse: [ self visitInterior: aSend args first asVisitor: aVisitor ]
	].
	aVisitor resultStream nextPut: $].
]

{ #category : 'visiting' }
ZagArrayAccessConverter >> visitInterior: aSend asVisitor: aVisitor [
	(aSend isASSend and: [ self class intervalSelectors includes: aSend selector ]) ifTrue: [
		(self intervalConverter: aSend) visit: aSend asVisitor: aVisitor.
	] ifFalse: [
		aVisitor visit: aSend.
		self isZeroIndexed ifFalse: [ aVisitor resultStream nextPutAll: ' - 1' ]. ].
]

{ #category : 'visiting' }
ZagArrayAccessConverter >> visitSplatCascadePart: aSend asVisitor: aVisitor [
	"Visit a part of a splattable cascade expression."
	aSend selector = #addAll: ifTrue: [ aVisitor resultStream nextPut: $* ].
	self visitInterior: aSend args first asVisitor: aVisitor.
]
