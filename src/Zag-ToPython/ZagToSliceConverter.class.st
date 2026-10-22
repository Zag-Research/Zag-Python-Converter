"
I am a ZagSendConverter that converts multiple types of calls to slices.
"
Class {
	#name : 'ZagToSliceConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'isZeroIndexed',
		'hasStep'
	],
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagToSliceConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #zwCopyFrom:to: putRule: (self new isZeroIndexed: true; hasStep: false; yourself).
	aClass at: #copyFrom:to: putRule: (self new isZeroIndexed: false; hasStep: false; yourself).
	aClass at: #zwCopyFrom:to:by: putRule: (self new isZeroIndexed: true; hasStep: true; yourself).
]

{ #category : 'accessing' }
ZagToSliceConverter >> hasStep [

	^ hasStep
]

{ #category : 'accessing' }
ZagToSliceConverter >> hasStep: anObject [

	hasStep := anObject
]

{ #category : 'accessing' }
ZagToSliceConverter >> isZeroIndexed [

	^ isZeroIndexed
]

{ #category : 'accessing' }
ZagToSliceConverter >> isZeroIndexed: anObject [

	isZeroIndexed := anObject
]

{ #category : 'visiting' }
ZagToSliceConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor visit: aSend target.
	aVisitor resultStream nextPut: $[.
	aVisitor visit: aSend args first.
	self isZeroIndexed ifFalse: [ aVisitor resultStream nextPutAll: ' - 1' ].
	aVisitor resultStream nextPut: $:.
	aSend args last = (ASLiteral literal: nil) ifFalse: [ aVisitor visit: aSend args second ].
	self hasStep ifTrue: [
		aVisitor resultStream nextPut: $:.
		aVisitor visit: aSend args third. 
	].
	aVisitor resultStream nextPut: $].
]
