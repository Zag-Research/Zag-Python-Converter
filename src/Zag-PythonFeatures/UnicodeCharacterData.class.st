"
I store data about a certain Unicode character.  My #codepoint variable contains the Unicode codepoint I represent, while my #unicodeName contains that character's unicode name(s).
"
Class {
	#name : 'UnicodeCharacterData',
	#superclass : 'Object',
	#instVars : [
		'codepoint',
		'unicodeName'
	],
	#category : 'Zag-PythonFeatures-Unicode',
	#package : 'Zag-PythonFeatures',
	#tag : 'Unicode'
}

{ #category : 'accessing' }
UnicodeCharacterData >> codepoint [

	^ codepoint
]

{ #category : 'accessing' }
UnicodeCharacterData >> codepoint: anObject [

	codepoint := anObject
]

{ #category : 'testing' }
UnicodeCharacterData >> matchesName: aString [
	"Check if aString is one of my names."
	^self unicodeName isCollection
		ifTrue: [ self unicodeName includes: aString ]
		ifFalse: [ self unicodeName = aString ]
]

{ #category : 'accessing' }
UnicodeCharacterData >> unicodeName [

	^ unicodeName
]

{ #category : 'accessing' }
UnicodeCharacterData >> unicodeName: anObject [

	unicodeName := anObject
]
