"
A ZagSendConverter for ifTrue:ifFalse:
"
Class {
	#name : 'ZagIfTrueIfFalseConverter',
	#superclass : 'ZagIfElseConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagIfTrueIfFalseConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #ifTrue:ifFalse: putRule: self new
]

{ #category : 'parsing' }
ZagIfTrueIfFalseConverter >> sendToSwitch: aSend [
	"Converts the provided ASSend to a list of associations."
	"Each association should map a condition AST to a block AST."
	^{ aSend target -> aSend args first. true -> aSend args last }
]
