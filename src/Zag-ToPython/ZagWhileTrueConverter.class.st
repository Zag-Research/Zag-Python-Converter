"
I am the ZagSendConverter for the whileTrue: message.
"
Class {
	#name : 'ZagWhileTrueConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagWhileTrueConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #whileTrue: putRule: self new.
	aClass at: #whileFalse: putRule: ZagWhileFalseConverter new.
]

{ #category : 'visiting' }
ZagWhileTrueConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASBlock ifFalse: [ self error: 'While condition must be a block.' ].
	aSend target body size = 1 ifFalse: [ self notYetImplemented ].
	aVisitor resultStream nextPutAll: 'while '.
	aVisitor visit: aSend target body first.
	aVisitor resultStream nextPut: $:; nextPut: Character cr.
	aVisitor addIndent: 1.
	aVisitor visitStatements: aSend args first.
	aVisitor addIndent: -1.
]
