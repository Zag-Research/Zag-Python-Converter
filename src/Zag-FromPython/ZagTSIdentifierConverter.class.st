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

{ #category : 'converting' }
ZagTSIdentifierConverter >> convertToZagAST: aZagTSNode [
	| identifier |
	identifier := aZagTSNode sourcePart asSymbol.
	^self class pythonBuiltinIdentifiers
		at: identifier
		ifPresent: [ :object | ASLiteral literal: object ]
		ifAbsent: [ ASRef variable: identifier ].
]
