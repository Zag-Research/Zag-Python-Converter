"
A ZagSendConverter for the array sets at:put: and zwAt:put:
"
Class {
	#name : 'ZagArraySetConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'isZeroIndexed'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagArraySetConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #at:put: putRule: (self new isZeroIndexed: false).
	aClass at: #zwAt:put: putRule: (self new isZeroIndexed: true).
]

{ #category : 'visiting' }
ZagArraySetConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	(ZagArrayAccessConverter new isZeroIndexed: self isZeroIndexed)
		accept: aSend asVisitor: aVisitor.
	aVisitor resultStream nextPutAll: ' = '.
	aVisitor visit: aSend args last.
]

{ #category : 'accessing' }
ZagArraySetConverter >> isZeroIndexed [

	^ isZeroIndexed
]

{ #category : 'accessing' }
ZagArraySetConverter >> isZeroIndexed: aBoolean [
	isZeroIndexed := aBoolean
]
