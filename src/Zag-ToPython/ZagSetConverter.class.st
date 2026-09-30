"
I am the ZagSendConverter for set literals (the asSet message).
"
Class {
	#name : 'ZagSetConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagSetConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #asSet putRule: self new
]

{ #category : 'visiting' }
ZagSetConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASLiteral ifTrue: [
		"can't use outputCollection because literal elements are not ASLiterals."
		aVisitor resultStream nextPut: ${.
		aSend target literal
			do: [ :each | aVisitor resultStream nextPutAll: each asString ]
			separatedBy: [ aVisitor resultStream nextPutAll: ', ' ].
		^aVisitor resultStream nextPut: $}. ].
	(aSend target isKindOf: ASArray) ifTrue: [ 
		^aVisitor outputCollection: aSend target statements begin: '{' end: '}' separator: ', ' ].
	^aVisitor outputCall: #set args: { aSend target }.
]
