"
I am the ZagSendConverter for the asDictionary message.
"
Class {
	#name : 'ZagDictionaryConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagDictionaryConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #asDictionary putRule: self new
]

{ #category : 'visiting' }
ZagDictionaryConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPut: ${.
	aSend target statements
		do: [ :each |
			aVisitor visit: each target.
			aVisitor resultStream nextPutAll: ': '.
			aVisitor visit: each args first.
		] separatedBy: [ aVisitor resultStream nextPutAll: ', ' ].
	aVisitor resultStream nextPut: $}.
]
