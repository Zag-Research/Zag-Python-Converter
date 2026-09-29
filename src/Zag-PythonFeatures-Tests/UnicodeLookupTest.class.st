Class {
	#name : 'UnicodeLookupTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Unicode',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Unicode'
}

{ #category : 'running' }
UnicodeLookupTest >> setUp [
	super setUp.
	"Put here a common initialization logic for tests"
	[ UnicodeLookup initialized ifFalse: [ UnicodeLookup initialize ] ]
		on: NameLookupFailure
		do: [ TestSkipped signal: 'Could not access Unicode data.' ]
]

{ #category : 'tests' }
UnicodeLookupTest >> testCharacterFromName [
	self assert: (UnicodeLookup characterNamed: 'LATIN CAPITAL LETTER A') equals: $A.
	self assert: (UnicodeLookup characterNamed: 'MULTIPLICATION SIGN') equals: $×.
]

{ #category : 'tests' }
UnicodeLookupTest >> testCharacterName [
	self assert: (UnicodeLookup unicodeNameOf: $A) equals: 'LATIN CAPITAL LETTER A'.
	self assert: (UnicodeLookup unicodeNameOf: $×) equals: 'MULTIPLICATION SIGN'.
]
