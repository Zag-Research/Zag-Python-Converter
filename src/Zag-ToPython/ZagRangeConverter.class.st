"
I am a ZagSendConverter for the to: and toExclusive: messages.
"
Class {
	#name : 'ZagRangeConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'isExclusive',
		'hasStep'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagRangeConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #to: putRule: (self new isExclusive: false; hasStep: false).
	aClass at: #to:by: putRule: (self new isExclusive: false; hasStep: true).
	aClass at: #toExclusive: putRule: (self new isExclusive: true; hasStep: false).
	aClass at: #toExclusive:by: putRule: (self new isExclusive: true; hasStep: true).
]

{ #category : 'visiting' }
ZagRangeConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'range('.
	aVisitor visit: aSend target.
	aVisitor resultStream nextPutAll: ', '.
	self isExclusive ifFalse: [ aVisitor resultStream nextPut: $( ].
	aVisitor visit: aSend args first.
	self isExclusive ifFalse: [ aVisitor resultStream nextPutAll: ') + 1' ].
	self hasStep ifTrue: [
		aVisitor resultStream nextPutAll: ', '.
		aVisitor visit: aSend args last.
	].
	aVisitor resultStream nextPut: $).
]

{ #category : 'accessing' }
ZagRangeConverter >> hasStep [

	^ hasStep
]

{ #category : 'accessing' }
ZagRangeConverter >> hasStep: aBoolean [

	hasStep := aBoolean
]

{ #category : 'accessing' }
ZagRangeConverter >> isExclusive [

	^ isExclusive
]

{ #category : 'accessing' }
ZagRangeConverter >> isExclusive: aBoolean [

	isExclusive := aBoolean
]
