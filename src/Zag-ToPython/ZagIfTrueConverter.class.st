"
A ZagSendConverter for ifTrue:
"
Class {
	#name : 'ZagIfTrueConverter',
	#superclass : 'ZagIfElseConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagIfTrueConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #ifTrue: putRule: self new
]

{ #category : 'parsing' }
ZagIfTrueConverter >> sendToSwitch: aSend [
	"Converts the provided ASSend to a list of associations."
	"Each association should map a condition AST to a block AST."
	^{ aSend target -> aSend args first }
]
