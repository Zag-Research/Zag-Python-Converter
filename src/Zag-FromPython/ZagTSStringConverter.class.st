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
	^ASLiteral literal: (aZagTSNode >> 2) sourcePart.
]
