"
A Zag converter for the onErrorDo: message.
"
Class {
	#name : 'ZagOnErrorDoConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagOnErrorDoConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #onErrorDo: putRule: self new
]

{ #category : 'visiting' }
ZagOnErrorDoConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'try:'; nextPut: Character cr.
	aVisitor addIndent: 1; visitStatements: aSend target; addIndent: -1.
	aVisitor resultStream nextPutAll: 'except:'; nextPut: Character cr.
	aVisitor addIndent: 1; visitStatements: aSend args first; addIndent: -1.
]
