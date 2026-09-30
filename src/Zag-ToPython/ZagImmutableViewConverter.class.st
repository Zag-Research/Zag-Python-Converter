"
I am the ZagSendConverter for #immutableView.
"
Class {
	#name : 'ZagImmutableViewConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagImmutableViewConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #immutableView putRule: self new
]

{ #category : 'visiting' }
ZagImmutableViewConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	(aSend target isKindOf: ASArray)
		ifTrue: [ ^aVisitor outputCollection: aSend target statements begin: '(' end: ')' separator: ', ' ].
	(aSend target isASLiteral and: [ aSend target literal isCollection ])
		ifTrue: [ | literals |
			literals := aSend target literal collect: [ :each | ASLiteral literal: each ].
			^aVisitor outputCollection: literals begin: '(' end: ')' separator: ', '
	].
	self notYetImplemented
]
