"
I am the ZagSendConverter for the #i message.
"
Class {
	#name : 'ZagImaginaryConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagImaginaryConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #i putRule: self new
]

{ #category : 'visiting' }
ZagImaginaryConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASLiteral ifTrue: [
		aVisitor visitLiteral: aSend target.
		aVisitor resultStream nextPut: $j.
	] ifFalse: [ self notYetImplemented ]
]
