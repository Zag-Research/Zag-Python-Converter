"
I am the ZagSendConverter for the del statement.  Currently I only do statements of the form del a[b].
"
Class {
	#name : 'ZagDeleteConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagDeleteConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #removeAt: putRule: self new.
	aClass at: #removeKey: putRule: self new.
]

{ #category : 'visiting' }
ZagDeleteConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'del '.
	aVisitor visit: aSend target.
	aVisitor resultStream nextPut: $[.
	aVisitor visit: aSend args first.
	aVisitor resultStream nextPut: $].
]
