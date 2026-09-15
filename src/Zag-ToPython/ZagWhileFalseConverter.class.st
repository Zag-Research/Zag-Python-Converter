"
I am the ZagSendConverter for the whileTrue: message.
"
Class {
	#name : 'ZagWhileFalseConverter',
	#superclass : 'ZagWhileTrueConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'visiting' }
ZagWhileFalseConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	| negated |
	negated := ASSend
		target: aSend target negateLastStatement
		selector: aSend selector
		args: aSend args.
	super accept: negated asVisitor: aVisitor.
]
