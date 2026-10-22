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

{ #category : 'constants' }
ZagArrayAccessConverter class >> intervalSelectors [
	"A set of selectors that create intervals, which should create slices if they are an access's argument."
	^#(#to: #to:by: #toExclusive: #toExclusive:by:) asSet
]

{ #category : 'testing' }
ZagArrayAccessConverter class >> isIntervalSend: aSend [
	"Returns true iff aSend is an array access with an interval argument."
	aSend isASSend ifFalse: [ ^false ].
	aSend args isEmpty ifTrue: [ ^false ].
	aSend args first isASSend ifFalse: [ ^false ].
	^self intervalSelectors includes: aSend args first selector.
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
	(self class isIntervalSend: aSend) ifTrue: [
		(self intervalConverter: aSend args first) visit: aSend args first asVisitor: aVisitor.
	] ifFalse: [
		aVisitor visit: aSend args first.
		self isZeroIndexed ifFalse: [ aVisitor resultStream nextPutAll: ' - 1' ]. ].
	aVisitor resultStream nextPut: $].
]
