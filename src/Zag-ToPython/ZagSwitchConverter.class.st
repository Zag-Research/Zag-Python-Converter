"
A ZagSendConverter for ifTrue:
"
Class {
	#name : 'ZagSwitchConverter',
	#superclass : 'ZagIfElseConverter',
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagSwitchConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #switch putRule: self new
]

{ #category : 'parsing' }
ZagSwitchConverter >> sendToSwitch: aSend [
	"Converts the provided ASSend to a list of associations."
	"Each association should map a condition AST to a block AST."
	^aSend target statements collect: [ :each | each selector = #->
		ifTrue: [ each target -> each args first ]
		ifFalse: [ self error: 'Invalid selector for switch statement part.' ] ]
]
