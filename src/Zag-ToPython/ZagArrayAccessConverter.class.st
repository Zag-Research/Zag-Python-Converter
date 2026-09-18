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

{ #category : 'setting' }
ZagArrayAccessConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #at: putRule: (self new isZeroIndexed: false).
	aClass at: #zwAt: putRule: (self new isZeroIndexed: true).
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
	aVisitor visit: aSend args first.
	self isZeroIndexed ifFalse: [ aVisitor resultStream nextPutAll: ' - 1' ].
	aVisitor resultStream nextPut: $].
]
