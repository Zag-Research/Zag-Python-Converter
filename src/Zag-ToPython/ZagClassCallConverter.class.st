"
I am a ZagSendConverter for the simple case where the correct Python code is simply to call a Python function with the send's arguments, but the send is calling a class method (i.e. the target is a class).  #pythonSelectorDict maps the Smalltalk target class to the name of the Python function to translate to.
"
Class {
	#name : 'ZagClassCallConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'pythonSelectorDict'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagClassCallConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #fromNumberOrString: putRule: (
		self new pythonSelectorSwitch: { #ByteArray -> #bytearray } asDictionary).
]

{ #category : 'visiting' }
ZagClassCallConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASRef ifFalse: [ self error: 'Target of class calls should be an ASRef.' ].
	self pythonSelectorSwitch
		at: aSend target variable
		ifPresent: [ :pythonSelector | aVisitor outputCall: pythonSelector args: aSend args ]
		ifAbsent: [ self error: 'No converter found for this selector & target.' ]
]

{ #category : 'accessing' }
ZagClassCallConverter >> pythonSelectorSwitch [

	^ pythonSelectorDict
]

{ #category : 'accessing' }
ZagClassCallConverter >> pythonSelectorSwitch: aDictionary [

	pythonSelectorDict := aDictionary
]
