"
A ZagSendConverter for assertWithDescription:
"
Class {
	#name : 'ZagAssertDescriptionConverter',
	#superclass : 'ZagAssertConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'visiting' }
ZagAssertDescriptionConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	super accept: aSend asVisitor: aVisitor.
	aVisitor resultStream nextPutAll: ', '.
	aVisitor visit: aSend args first.
]
