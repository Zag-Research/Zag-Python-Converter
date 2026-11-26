"
I convert types from Zag to Smalltalk.
"
Class {
	#name : 'ZagTSTypeConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSTypeConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #type putRule: self new
]

{ #category : 'constants' }
ZagTSTypeConverter class >> typeConversions [
	"Returns a dictionary from known Python types (symbols) to Zag types (class objects)."
	^{
		#int -> Integer.  #float -> Float.  #str -> String.
	} asDictionary
]

{ #category : 'converting' }
ZagTSTypeConverter >> convertToZagAST: aZagTSNode [
	^self class typeConversions
		at: (aZagTSNode >> 1) sourcePart asSymbol
		ifAbsent: [ self error: 'No conversion found for provided type' ]
]
