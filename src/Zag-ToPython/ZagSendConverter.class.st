"
I encode a transformation rule for certain ASSend selector(s).
"
Class {
	#name : 'ZagSendConverter',
	#superclass : 'Object',
	#classVars : [
		'ConverterRules'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'visiting' }
ZagSendConverter class >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor."
	self isInitialized ifFalse: [ self initialize ].
	ConverterRules
		at: aSend selector
		ifPresent: [ :converter | converter accept: aSend asVisitor: aVisitor ]
		ifAbsent: [ self error: 'No converter found for provided send' ].
]

{ #category : 'setting' }
ZagSendConverter class >> at: aSelector putRule: aConverter [
	"Add a conversion rule for the provided selector."
	"The rule, aConverter, should be an instance of a subclass of ZagSendConverter."
	"This method will raise an error if aSelector already has a rule."
	ConverterRules
		at: aSelector
		ifPresent: [ self error: 'Subclass attempted to add a duplicate rule.' ]
		ifAbsentPut: [ aConverter ]
]

{ #category : 'accessing' }
ZagSendConverter class >> converterRules [
	"Returns a copy of my converter rules dictionary."
	self isInitialized ifFalse: [ self initialize ].
	^ConverterRules copy.
]

{ #category : 'class initialization' }
ZagSendConverter class >> initialize [
	"Initialize the class.  If called multiple times, reinitializes."
	ConverterRules := Dictionary new.
	self subclassesDo: [ :each | each putRules: self ].
]

{ #category : 'testing' }
ZagSendConverter class >> isInitialized [
	^ConverterRules isNotNil
]

{ #category : 'setting' }
ZagSendConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	self subclassResponsibility
]

{ #category : 'visiting' }
ZagSendConverter >> accept: aSend asVisitor: aVisitor [
	"Converts aSend to Python, outputting the code to aVisitor.  You may call its visiting helpers."
	"This method assumes, and will only be called if, aSend's selector is appropriate for this object."
	self subclassResponsibility
]
