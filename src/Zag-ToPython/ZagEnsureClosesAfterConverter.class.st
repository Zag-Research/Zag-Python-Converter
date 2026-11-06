"
I am the ZagSendConverter for ensureClosesAfter:.  I convert it to a with statement.
"
Class {
	#name : 'ZagEnsureClosesAfterConverter',
	#superclass : 'ZagSendConverter',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'setting' }
ZagEnsureClosesAfterConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #ensureClosesAfter: putRule: self new
]

{ #category : 'visiting' }
ZagEnsureClosesAfterConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor resultStream nextPutAll: 'with '.
	aVisitor visit: aSend target body first.
	aVisitor resultStream nextPutAll: ' as '.
	aVisitor visit: aSend args first arguments first.
	aVisitor resultStream nextPut: $:; nextPut: Character cr.
	aVisitor visitIndentedBlock: aSend args first.
	
]
