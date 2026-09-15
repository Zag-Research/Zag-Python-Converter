"
I am a ZagSendConverter for the do: message.
"
Class {
	#name : 'ZagForEachConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagForEachConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #do: putRule: self new
]

{ #category : 'visiting' }
ZagForEachConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'for '.
	aVisitor visitRef: aSend args first arguments first.
	aVisitor resultStream nextPutAll: ' in '.
	aVisitor visit: aSend target.
	aVisitor resultStream nextPut: $:; nextPut: Character cr.
	aVisitor addIndent: 1.
	aVisitor visitStatements: aSend args first.
	aVisitor addIndent: -1.
]
