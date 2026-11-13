Class {
	#name : 'NameDemanglingTest',
	#superclass : 'TestCase',
	#category : 'Zag-ToPython-Tests-Tests',
	#package : 'Zag-ToPython-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
NameDemanglingTest >> testIdentityDemangling [
	self assert: (ZagToPythonVisitor shouldBeDemangled: #__test forClass: #__).
	self assert: (ZagToPythonVisitor demangle: #__test forClass: #__) equals: #__test.
]

{ #category : 'tests' }
NameDemanglingTest >> testNonMangledName [
	self deny: (ZagToPythonVisitor shouldBeDemangled: #hi forClass: #Class).
]

{ #category : 'tests' }
NameDemanglingTest >> testSimpleDemangling [
	self assert: (ZagToPythonVisitor shouldBeDemangled: #_Class__test forClass: #_Class).
	self assert: (ZagToPythonVisitor demangle: #_Class__test forClass: #_Class) equals: #__test.
]
