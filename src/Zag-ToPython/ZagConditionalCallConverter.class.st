"
I am a ZagSendConverter for the simple case where the correct Python code is simply to call a Python function with the send's arguments.  I allow arbitrary conditions to be imposed on the send to create different calls.

My variable `#pythonSelectorSwitch` is a list of associations mapping conditions (blocks that accept the send and return a boolean) to selectors.  The selector of the first block that returns true will be returned.
"
Class {
	#name : 'ZagConditionalCallConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'pythonSelectorSwitch'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'testing' }
ZagConditionalCallConverter class >> isInput: aSend [
	"Tests if a send should be translated to an input() statement."
	^aSend target isASSend and: [
		 aSend target target = (ASRef variable: #UIManager) and:
			[ aSend target selector = #default ] ].
]

{ #category : 'setting' }
ZagConditionalCallConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #request: putRule: (self new pythonSelectorSwitch: {
		[ :aSend | self isInput: aSend ] -> #input
	}).
]

{ #category : 'visiting' }
ZagConditionalCallConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	self pythonSelectorSwitch
		detect: [ :condition | condition key value: aSend ]
		ifFound: [ :condition | aVisitor outputCall: condition value args: aSend args ]
		ifNone: [ self error: 'No converter found for this send.' ]
]

{ #category : 'accessing' }
ZagConditionalCallConverter >> pythonSelectorSwitch [

	^ pythonSelectorSwitch
]

{ #category : 'accessing' }
ZagConditionalCallConverter >> pythonSelectorSwitch: aSwitch [

	pythonSelectorSwitch := aSwitch
]
