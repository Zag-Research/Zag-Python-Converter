"
I am the ZagTSConverter for builtin functions.  I have my own rules for my subclasses like the ZagTSConverter class.
"
Class {
	#name : 'ZagTSBuiltinConverter',
	#superclass : 'Object',
	#classVars : [
		'BuiltinConverterRules'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSBuiltinConverter class >> at: aSymbol putBuiltinRule: aConverter [
	"Adds a builtin conversion rule for the provided function name."
	BuiltinConverterRules
		at: aSymbol
		ifPresent: [ self error: 'Subclass attempted to add a duplicate rule.' ]
		ifAbsentPut: [ aConverter ]
]

{ #category : 'class initialization' }
ZagTSBuiltinConverter class >> builtinConverterRules [
	self isInitialized ifFalse: [ self initialize ].
	^BuiltinConverterRules copy.
]

{ #category : 'converting' }
ZagTSBuiltinConverter class >> builtinToZagAST: aBuiltin [
	"Convert the provided builtin function call to the Zag AST."
	self isInitialized ifFalse: [ self initialize ].
	^BuiltinConverterRules
		at: (aBuiltin >> 1) sourcePart asSymbol
		ifPresent: [ :converter | converter convertToZagAST: aBuiltin ]
		ifAbsent: [ self error: 'No converter found for provided node type' ].
]

{ #category : 'class initialization' }
ZagTSBuiltinConverter class >> initialize [
	BuiltinConverterRules := Dictionary new.
	self subclassesDo: [ :each | each putBuiltinRules: self ].
]

{ #category : 'class initialization' }
ZagTSBuiltinConverter class >> isInitialized [
	^BuiltinConverterRules isNotNil
]

{ #category : 'class initialization' }
ZagTSBuiltinConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	self subclassResponsibility
]

{ #category : 'converting' }
ZagTSBuiltinConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	self subclassResponsibility
]
