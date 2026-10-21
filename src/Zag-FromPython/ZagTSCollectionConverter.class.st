"
I am a ZagTSConverter for collection literals.
"
Class {
	#name : 'ZagTSCollectionConverter',
	#superclass : 'ZagTSConverter',
	#instVars : [
		'conversionSelector'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSCollectionConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #list putRule: (self new conversionSelector: #asOrderedCollection).
	aClass at: #tuple putRule: (self new conversionSelector: #immutableView).
	aClass at: #set putRule: (self new conversionSelector: #asSet).
	self subclassesDo: [ :subclass | subclass putRules: aClass ].
]

{ #category : 'accessing' }
ZagTSCollectionConverter >> conversionSelector [

	^ conversionSelector
]

{ #category : 'accessing' }
ZagTSCollectionConverter >> conversionSelector: anObject [

	conversionSelector := anObject
]

{ #category : 'converting' }
ZagTSCollectionConverter >> convertChild: aChild [
	"Convert one element of this collection to Zag"
	^aChild asZagASTNode
]

{ #category : 'converting' }
ZagTSCollectionConverter >> convertToZagAST: aZagTSNode [
	| arrayPart |
	arrayPart := aZagTSNode children collect: [ :child | self convertChild: child ] as: ASArray.
	^self conversionSelector
		ifNil: [ arrayPart ]
		ifNotNil: [ ASSend target: arrayPart selector: self conversionSelector ].
]
