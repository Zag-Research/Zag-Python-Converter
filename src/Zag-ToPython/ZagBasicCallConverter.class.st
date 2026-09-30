"
I am a ZagSendConverter for the simple case where the correct Python code is simply to call a Python function with the send's arguments.  The target becomes the first argument.  #pythonSelector is the name of the Python function to translate to.
"
Class {
	#name : 'ZagBasicCallConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'pythonSelector'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagBasicCallConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #asInteger putRule: (self new pythonSelector: #int).
	aClass at: #asNumber putRule: (self new pythonSelector: #float).
	aClass at: #asString putRule: (self new pythonSelector: #str).
]

{ #category : 'accessing' }
ZagBasicCallConverter >> pythonSelector [

	^ pythonSelector
]

{ #category : 'accessing' }
ZagBasicCallConverter >> pythonSelector: aSymbol [

	pythonSelector := aSymbol
]

{ #category : 'visiting' }
ZagBasicCallConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aVisitor outputCall: self pythonSelector args: { aSend target }
	
]
