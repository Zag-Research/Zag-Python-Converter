"
I am the ZagTSConverter for the break and continue keywords.
"
Class {
	#name : 'ZagTSBreakContinueConverter',
	#superclass : 'ZagTSConverter',
	#instVars : [
		'keyword'
	],
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'constants' }
ZagTSBreakContinueConverter class >> breakableBlockClosureName [
	"The name of the variable used for breakable block closures."
	"Python break/continue only works on the innmost loop, so it's actually correct to only use one variable and let inner loops shadow outer loops."
	^#breakableBlockClosure
]

{ #category : 'class initialization' }
ZagTSBreakContinueConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #break_statement putRule: (self new keyword: #break; yourself).
	aClass at: #continue_statement putRule: (self new keyword: #continue; yourself).
]

{ #category : 'converting' }
ZagTSBreakContinueConverter >> convertToZagAST: aZagTSNode [
	^ASSend target: (ASRef variable: self class breakableBlockClosureName) selector: self keyword
]

{ #category : 'accessing' }
ZagTSBreakContinueConverter >> keyword [

	^ keyword
]

{ #category : 'accessing' }
ZagTSBreakContinueConverter >> keyword: anObject [

	keyword := anObject
]
