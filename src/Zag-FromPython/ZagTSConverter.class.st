"
I encode a transformation rule for certain kinds of tree-sitter nodes.
"
Class {
	#name : 'ZagTSConverter',
	#superclass : 'Object',
	#classVars : [
		'ConverterRules'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSConverter class >> at: aType putRule: aConverter [
	"Add a conversion rule for the provided node type."
	"The rule, aConverter, should be an instance of a subclass of ZagTSConverter."
	"This method will raise an error if aType already has a rule."
	ConverterRules
		at: aType
		ifPresent: [ self error: 'Subclass attempted to add a duplicate rule.' ]
		ifAbsentPut: [ aConverter ]
]

{ #category : 'converting' }
ZagTSConverter class >> convertToZagAST: aZagTSNode [
	"Converts aZagTSNode to Python returning the AST."
	self isInitialized ifFalse: [ self initialize ].
	^ConverterRules
		at: aZagTSNode tsNodeType
		ifPresent: [ :converter | converter convertToZagAST: aZagTSNode ]
		ifAbsent: [ self error: 'No converter found for provided node type' ].
]

{ #category : 'class initialization' }
ZagTSConverter class >> converterRules [
	"Returns a copy of my converter rules dictionary."
	self isInitialized ifFalse: [ self initialize ].
	^ConverterRules copy.
]

{ #category : 'class initialization' }
ZagTSConverter class >> initialize [
	ConverterRules := Dictionary new.
	self subclassesDo: [ :each | each putRules: self ].
]

{ #category : 'class initialization' }
ZagTSConverter class >> isInitialized [
	^ConverterRules isNotNil
]

{ #category : 'class initialization' }
ZagTSConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	self subclassResponsibility
]

{ #category : 'converting' }
ZagTSConverter >> convertToZagAST: aZagTSNode [
	self subclassResponsibility
]
