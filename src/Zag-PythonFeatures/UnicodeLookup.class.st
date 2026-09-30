"
I contain some messages that can be used to look up the names of Unicode characters.
"
Class {
	#name : 'UnicodeLookup',
	#superclass : 'Object',
	#classVars : [
		'NamesToCodepoints',
		'UnicodeData'
	],
	#category : 'Zag-PythonFeatures-Unicode',
	#package : 'Zag-PythonFeatures',
	#tag : 'Unicode'
}

{ #category : 'accessing' }
UnicodeLookup class >> characterNamed: aString [
	^self characterNamed: aString ifPresent: [ :c | c ] ifAbsent: [ nil ]
]

{ #category : 'accessing' }
UnicodeLookup class >> characterNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [
	"Gets the character with the provided unicode name.  If present, run presentBlock with the name as an argument.  If absent, run absentBlock."
	self initialized ifFalse: [ self initialize ].
	^NamesToCodepoints
		at: aString
		ifPresent: [ :codepoint | presentBlock cull: codepoint asCharacter ]
		ifAbsent: absentBlock
]

{ #category : 'class initialization' }
UnicodeLookup class >> initialize [
	"Setup my character data.  Makes an API request to unicode.org."
	| response |
	[ response := ZnClient new url: self unicodeDataURL; get; response ]
		on: Error do: [ :err | self error: 'Could not get online Unicode data.' ].
	UnicodeData := Dictionary new: 1 << 16.
	NamesToCodepoints := Dictionary new: 1 << 16.
	response contents linesDo: [ :line | | data |
		data := self unicodeDataFromLine: line.
		UnicodeData at: data codepoint put: data.
		NamesToCodepoints at: data unicodeName put: data codepoint.
	]
]

{ #category : 'testing' }
UnicodeLookup class >> initialized [
	"Returns true iff I have been initialized."
	^UnicodeData isNotNil & NamesToCodepoints isNotNil
]

{ #category : 'parsing' }
UnicodeLookup class >> unicodeDataFromLine: line [
	| parts codepoint unicodeName |
	parts := line splitOn: ';'.
	codepoint := Integer readFrom: parts first base: 16.
	unicodeName := parts at: 2.
	(unicodeName first = $< and: [ unicodeName last = #> ])
		ifTrue: [ unicodeName := parts at: 11 ].
	^UnicodeCharacterData new codepoint: codepoint; unicodeName: unicodeName; yourself.
]

{ #category : 'constants' }
UnicodeLookup class >> unicodeDataURL [
	"The URL at which the Unicode data I use is stored."
	^'https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt'
]

{ #category : 'accessing' }
UnicodeLookup class >> unicodeNameOf: aCharacter [
	^self
		unicodeNameOf: aCharacter
		ifPresent: [ :unicodeName | unicodeName ]
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
UnicodeLookup class >> unicodeNameOf: aCharacter ifPresent: presentBlock ifAbsent: absentBlock [
	"Gets a character's unicode name.  If present, run presentBlock with the name as an argument.  If absent, run absentBlock."
	self initialized ifFalse: [ self initialize ].
	^UnicodeData
		at: aCharacter codePoint
		ifPresent: [ :data | presentBlock cull: data unicodeName ]
		ifAbsent: absentBlock
]
