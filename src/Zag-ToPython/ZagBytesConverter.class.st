"
I am the ZagSend converter for the asByteArray message.

If my target is a string literal, I return it as a bytes literal.  Otherwise, I return a call to bytearray().
"
Class {
	#name : 'ZagBytesConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagBytesConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #asByteArray putRule: self new
]

{ #category : 'visiting' }
ZagBytesConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	(aSend target isASLiteral and: [ aSend target literal isString ])
		ifTrue: [ aVisitor resultStream nextPut: $b. aVisitor visit: aSend target ]
		ifFalse: [ aVisitor outputCall: #bytearray args: { aSend target } ]
]
