"
I am a ZagSendConverter for assert statements.
"
Class {
	#name : 'ZagAssertConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagAssertConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #assert putRule: self new.
	aClass at: #assertWithDescription: putRule: ZagAssertDescriptionConverter new.
]

{ #category : 'visiting' }
ZagAssertConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	(aSend target isASBlock and: [ aSend target body size = 1 ]) ifFalse: [ self notYetImplemented ].
	aVisitor resultStream nextPutAll: 'assert '.
	aVisitor visit: aSend target body first.
]
