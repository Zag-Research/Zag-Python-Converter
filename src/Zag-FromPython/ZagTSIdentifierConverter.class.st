"
I am the ZagTSConverter for identifiers (variables and some constants).
"
Class {
	#name : 'ZagTSIdentifierConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'transformations' }
ZagTSIdentifierConverter class >> mangleName: aName forClass: aClassName [
	"Mangles a private name, using the provided class name."
	| isUnderscore nameString classNameString mangledNameString |
	isUnderscore := [ :char | char = $_ ].
	nameString := aName asString.
	classNameString := aClassName asString.
	(classNameString allSatisfy: isUnderscore) ifTrue: [ ^aName ].
	mangledNameString := '_',(classNameString trimLeft: isUnderscore),nameString.
	^mangledNameString asSymbol
	
]

{ #category : 'class initialization' }
ZagTSIdentifierConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #identifier putRule: self new
]

{ #category : 'constants' }
ZagTSIdentifierConverter class >> pythonBuiltinIdentifiers [
	"A dictionary mapping symbols of Python builtin identifiers to their Zag equivalents."
	^{
		#Ellipsis -> Ellipsis.
		#NotImplemented -> NotImplemented.
		#BaseException -> Exception.
		#Exception -> Error.
		#ArithmeticError -> ArithmeticError.
	} asDictionary
]

{ #category : 'testing' }
ZagTSIdentifierConverter class >> shouldBeMangled: aName [
	"Determines if a private identifier should be mangled (assuming it is in a class.)"
	| aNameString |
	aNameString := aName asString.
	^(aNameString beginsWith: '__') and: [ (aNameString endsWith: '__') not
		and: [ (aNameString includes: $.) not ] ]
]

{ #category : 'converting' }
ZagTSIdentifierConverter >> convertToZagAST: aZagTSNode [
	| identifier |
	identifier := aZagTSNode sourcePart asSymbol.
	^self class pythonBuiltinIdentifiers
		at: identifier
		ifPresent: [ :object | ASLiteral literal: object ]
		ifAbsent: [ ASRef variable: identifier ].
]
