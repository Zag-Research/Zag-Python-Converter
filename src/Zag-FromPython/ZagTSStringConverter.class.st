"
I am the ZagTSConverter for string literals.
"
Class {
	#name : 'ZagTSStringConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'constants' }
ZagTSStringConverter class >> basicEscapes [
	"Return all basic (i.e. doesn't take an 'argument') Python escape sequences."
	"This is a dictionary mapping the character after the backslash to the Smalltalk equivalent."
	^{
		$' -> $'. $" -> $". $\ -> $\. Character cr -> ''. "TODO allow \ to escape a full \r\n"
		$a -> 7 asCharacter. $b -> Character backspace. $f -> 12 asCharacter.
		$n -> Character lf. $r -> Character cr. $t -> Character tab. $v -> 11 asCharacter.
	} asDictionary
]

{ #category : 'parsing' }
ZagTSStringConverter class >> parseLiteral: aString [
	"Parses a Python string literal, converting all escape sequences into Unicode characters."
	| isEscape |
	isEscape := false.
	^String streamContents: [ :stream | aString do: [ :char |
		isEscape ifTrue: [
			self basicEscapes
				at: char
				ifPresent: [ :unescaped | stream << unescaped. isEscape := false. ]
				ifAbsent: [ self error: 'Invalid or unimplemented escape sequence.' ]
		] ifFalse: [
			char = $\
				ifTrue: [ isEscape := true ]
				ifFalse: [ stream nextPut: char. char = $' ifTrue: [ stream nextPut: $' ] ]
		]
	] ].
]

{ #category : 'class initialization' }
ZagTSStringConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #string putRule: self new
]

{ #category : 'parsing' }
ZagTSStringConverter class >> stringType: prefix [
	"Determines the type of a string literal based on its prefix.  Returns a set of type symbols."
	| aZagTSNode |
	aZagTSNode := self new.
	(#( 'bf' 'bt' 'ft' ) anySatisfy: [ :str | prefix asLowercase sorted includesSubstring: str ])
		ifTrue: [ aZagTSNode error: 'Invalid string prefix' ].
	^(prefix asLowercase reject: [ :char | char = $u ]) collect: [ :char | {
		char = $b -> #Bytes.
		char = $r -> #Raw.
		char = $f -> #Formatted.
		char = $t -> #Template.
		true -> [ self error: 'Unrecognized character' ] } switch ] as: Set
]

{ #category : 'converting' }
ZagTSStringConverter >> convertToZagAST: aZagTSNode [
	| pythonString pythonPrefix stringType smalltalkString |
	pythonString := (aZagTSNode >> 2) sourcePart.
	pythonPrefix := (aZagTSNode >> 1) sourcePart trimRight: [ :c | '''"' includes: c ].
	stringType := self class stringType: pythonPrefix.
	smalltalkString := (stringType includes: #Raw)
		ifTrue: [ pythonString replaceAll: '''' with: '''''' ]
		ifFalse: [ self class parseLiteral: pythonString ].
	^ASLiteral literal: smalltalkString.
]
