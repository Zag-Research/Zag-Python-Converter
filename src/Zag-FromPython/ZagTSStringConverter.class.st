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

{ #category : 'constants' }
ZagTSStringConverter class >> hexEscapeSizes [
	^{ $x -> 2. $u -> 4. $U -> 8 } asDictionary
]

{ #category : 'parsing' }
ZagTSStringConverter class >> parseEscape: escape [
	"Parses a Python escape sequence (excluding the backslash), returning the Smalltalk equivalent."
	"If the sequence is incomplete, return nil.  If it is invalid, raise an error."
	(escape allSatisfy: [ :c | '01234567' includes: c ])
		ifTrue: [ ^self parseEscape: escape expectedLength: 3 base: 8 ].
	self hexEscapeSizes at: escape first ifPresent: [ :size |
		(escape allButFirstDo: [ :c | c hexDigitValue ifNil: [ self error: 'Invalid hex escape' ] ]).
		^self parseEscape: escape allButFirst expectedLength: size base: 16 ].
	self basicEscapes
		at: escape first
		ifPresent: [ :unescaped | ^unescaped ]
		ifAbsent: [ self error: 'Invalid or unimplemented escape sequence.' ]
]

{ #category : 'parsing' }
ZagTSStringConverter class >> parseEscape: escape expectedLength: length base: base [
	^escape size = length ifTrue: [ | unicodeValue |
		unicodeValue := Integer readFrom: escape base: base.
		Character value: unicodeValue
	] ifFalse: [ nil ].
]

{ #category : 'parsing' }
ZagTSStringConverter class >> parseLiteral: aString [
	"Parses a Python string literal, converting all escape sequences into Unicode characters."
	| escape unescaped |
	escape := WriteStream on: OrderedCollection new.
	^String streamContents: [ :stream | aString do: [ :char |
		escape isEmpty ifFalse: [
			escape nextPut: char.
			unescaped := self parseEscape: (String newFrom: escape contents) allButFirst.
			unescaped ifNotNil: [ stream << unescaped. escape := WriteStream on: OrderedCollection new ]
		] ifTrue: [
			char = $\
				ifTrue: [ escape nextPut: $\ ]
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
	| pythonString pythonPrefix stringType smalltalkString literal |
	pythonString := (aZagTSNode >> 2) sourcePart.
	pythonPrefix := (aZagTSNode >> 1) sourcePart trimRight: [ :c | '''"' includes: c ].
	stringType := self class stringType: pythonPrefix.
	smalltalkString := (stringType includes: #Raw)
		ifTrue: [ pythonString replaceAll: '''' with: '''''' ]
		ifFalse: [ self class parseLiteral: pythonString ].
	literal := ASLiteral literal: smalltalkString.
	^(stringType includes: #Bytes)
		ifTrue: [ ASSend target: literal selector: #asByteArray args: #() ]
		ifFalse: [ literal ].
]
