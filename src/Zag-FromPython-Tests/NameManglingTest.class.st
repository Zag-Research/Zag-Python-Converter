Class {
	#name : 'NameManglingTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests-Tests',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
NameManglingTest >> testIdentityMangling [
	self assert: (ZagTSIdentifierConverter shouldBeMangled: #__test).
	self assert: (ZagTSIdentifierConverter mangleName: #__test forClass: #__) equals: #__test.
]

{ #category : 'tests' }
NameManglingTest >> testMangling [
	self assert: (ZagTSIdentifierConverter shouldBeMangled: #__test_).
	self assert: (ZagTSIdentifierConverter mangleName: #__test_ forClass: #_Class) equals: #_Class__test_
]

{ #category : 'tests' }
NameManglingTest >> testNonMangledName [
	self deny: (ZagTSIdentifierConverter shouldBeMangled: #publicName).
	self deny: (ZagTSIdentifierConverter shouldBeMangled: #_name).
	self deny: (ZagTSIdentifierConverter shouldBeMangled: #__name__).
]
