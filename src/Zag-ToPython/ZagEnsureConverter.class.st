"
I am the ZagSendConverter for the ensure: message.
"
Class {
	#name : 'ZagEnsureConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagEnsureConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #ensure: putRule: self new
]

{ #category : 'testing' }
ZagEnsureConverter >> targetIsTry: aSend [
	| targetSelector |
	aSend target isASBlock ifFalse: [ ^false ].
	aSend target body size = 1 ifFalse: [ ^false ].
	aSend target body first isASSend ifFalse: [ ^false ].
	targetSelector := aSend target body first selector.
	^self class converterRules at: targetSelector ifPresent: #isTryConverter ifAbsent: [ false ].
]

{ #category : 'visiting' }
ZagEnsureConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	(self targetIsTry: aSend) ifFalse: [
		aVisitor resultStream nextPutAll: 'try:'; nextPut: Character cr.
		aVisitor addIndent: 1.
	].
	aVisitor visitStatements: aSend target.
	(self targetIsTry: aSend)
		ifFalse: [ aVisitor addIndent: -1 ]
		ifTrue: [ aVisitor resultStream skip: -1 ].
	aVisitor resultStream nextPutAll: 'finally:'; nextPut: Character cr.
	aVisitor visitIndentedBlock: aSend args first.
]
