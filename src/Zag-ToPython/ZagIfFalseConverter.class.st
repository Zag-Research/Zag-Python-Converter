"
A ZagSendConverter for ifFalse:
"
Class {
	#name : 'ZagIfFalseConverter',
	#superclass : 'ZagIfElseConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagIfFalseConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #ifFalse: putRule: self new
]

{ #category : 'parsing' }
ZagIfFalseConverter >> sendToSwitch: aSend [
	"Converts the provided ASSend to a list of associations."
	"Each association should map a condition AST to a block AST."
	^{ aSend target -> nil. nil -> aSend args first }
]
