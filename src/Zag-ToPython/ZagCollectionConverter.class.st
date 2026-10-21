"
I am the ZagSendConverter for set and list literals (the asSet & asOrderedCollection messages).
"
Class {
	#name : 'ZagCollectionConverter',
	#superclass : 'ZagSendConverter',
	#instVars : [
		'literalStart',
		'literalEnd',
		'conversionCall'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'setting' }
ZagCollectionConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #asSet putRule: (
		self new literalStart: '{'; literalEnd: '}'; conversionCall: #set; yourself).
	aClass at: #asOrderedCollection putRule: (
		self new literalStart: '['; literalEnd: ']'; conversionCall: #list; yourself).
]

{ #category : 'accessing' }
ZagCollectionConverter >> conversionCall [
	"The Python builtin you can use to convert to my type"
	^ conversionCall
]

{ #category : 'accessing' }
ZagCollectionConverter >> conversionCall: anObject [

	conversionCall := anObject
]

{ #category : 'accessing' }
ZagCollectionConverter >> literalEnd [
	"The final character of literals I convert to."
	^ literalEnd
]

{ #category : 'accessing' }
ZagCollectionConverter >> literalEnd: anObject [

	literalEnd := anObject
]

{ #category : 'accessing' }
ZagCollectionConverter >> literalStart [
	"The initial character of literals I convert to"
	^ literalStart
]

{ #category : 'accessing' }
ZagCollectionConverter >> literalStart: anObject [

	literalStart := anObject
]

{ #category : 'visiting' }
ZagCollectionConverter >> visit: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	aSend target isASLiteral ifTrue: [
		"can't use outputCollection because literal elements are not ASLiterals."
		aVisitor resultStream nextPutAll: self literalStart.
		aSend target literal
			do: [ :each | aVisitor resultStream nextPutAll: each asString ]
			separatedBy: [ aVisitor resultStream nextPutAll: ', ' ].
		^aVisitor resultStream nextPutAll: self literalEnd. ].
	(aSend target isKindOf: ASArray) ifTrue: [ 
		^aVisitor outputCollection: aSend target statements begin: self literalStart end: self literalEnd separator: ', ' ].
	^aVisitor outputCall: self conversionCall args: { aSend target }.
]
