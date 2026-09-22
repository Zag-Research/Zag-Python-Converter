"
I am a ZagTSConverter that converts to the same object, my variable #constant, every time.  Used for True, False & None.
"
Class {
	#name : 'ZagTSConstantConverter',
	#superclass : 'ZagTSConverter',
	#instVars : [
		'constant'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSConstantConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	{ #true -> true. #false -> false. #none -> nil } asDictionary
		keysAndValuesDo: [ :k :v | aClass at: k putRule: (self new constant: (ASLiteral literal: v)) ]
]

{ #category : 'accessing' }
ZagTSConstantConverter >> constant [

	^ constant
]

{ #category : 'accessing' }
ZagTSConstantConverter >> constant: anObject [

	constant := anObject
]

{ #category : 'converting' }
ZagTSConstantConverter >> convertToZagAST: aZagTSNode [
	^self constant
]
