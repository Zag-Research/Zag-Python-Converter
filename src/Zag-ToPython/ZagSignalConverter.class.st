"
I convert the #signal message
"
Class {
	#name : 'ZagSignalConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagSignalConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #signal putRule: self new
]

{ #category : 'visiting' }
ZagSignalConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'raise '.
	aVisitor visit: aSend target.
]
