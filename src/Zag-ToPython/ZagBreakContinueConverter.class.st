"
I am the ZagSendConverter for break and continue.
"
Class {
	#name : 'ZagBreakContinueConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'keyword'
	],
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagBreakContinueConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #break putRule: (self new keyword: #break; yourself).
	aClass at: #continue putRule: (self new keyword: #continue; yourself).
]

{ #category : 'accessing' }
ZagBreakContinueConverter >> keyword [

	^ keyword
]

{ #category : 'accessing' }
ZagBreakContinueConverter >> keyword: anObject [

	keyword := anObject
]

{ #category : 'visiting' }
ZagBreakContinueConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASRef ifFalse: [ self error: 'break/continue target must be a variable' ].
	aVisitor resultStream nextPutAll: self keyword asString
]
