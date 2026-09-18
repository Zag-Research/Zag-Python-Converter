"
I am a set of tests that ensures the special methods handling Python's truthy semantics work properly.
"
Class {
	#name : 'PythonTruthyTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Basic Types',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Basic Types'
}

{ #category : 'tests' }
PythonTruthyTest >> testAnd [
	"Ensures pythonAnd: works properly."
	self assert: (0 pythonAnd: 0) equals: 0.
	self assert: (#() pythonAnd: nil) equals: #().
	self assert: (0 pythonAnd: 1) equals: 0.
	self assert: (1 pythonAnd: 0) equals: 0.
	self assert: (1 pythonAnd: 1) equals: 1.
	self assert: (3 pythonAnd: 2) equals: 2.
]

{ #category : 'tests' }
PythonTruthyTest >> testCollections [
	"Ensure empty collections are falsy, everything else truthy."
	self assert: #() toPythonBoolean equals: false.
	self assert: #(0) toPythonBoolean equals: true.
	self assert: OrderedCollection new toPythonBoolean equals: false.
	self assert: (OrderedCollection with: 0) toPythonBoolean equals: true.
	self assert: Dictionary new toPythonBoolean equals: false.
	self assert: (Dictionary newFrom: {0->0}) toPythonBoolean equals: true.
]

{ #category : 'tests' }
PythonTruthyTest >> testNot [
	"Ensure pythonNot works as expected."
	self assert: (0 pythonNot) equals: true.
	self assert: (1 pythonNot) equals: false.
]

{ #category : 'tests' }
PythonTruthyTest >> testNumbers [
	"Ensure that 0 is considered falsy, all others truthy."
	self assert: 0 toPythonBoolean equals: false.
	self assert: 1 toPythonBoolean equals: true.
	self assert: -1 toPythonBoolean equals: true.
]

{ #category : 'tests' }
PythonTruthyTest >> testOr [
	"Ensures pythonOr: works properly."
	self assert: (0 pythonOr: 0) equals: 0.
	self assert: (#() pythonOr: nil) equals: nil.
	self assert: (0 pythonOr: 1) equals: 1.
	self assert: (1 pythonOr: 0) equals: 1.
	self assert: (1 pythonOr: 1) equals: 1.
	self assert: (3 pythonOr: 2) equals: 3.
]

{ #category : 'tests' }
PythonTruthyTest >> testOthers [
	"Test that booleans, nil and other objects return the expected truthiness values."
	self assert: false toPythonBoolean equals: false.
	self assert: true toPythonBoolean equals: true.
	self assert: nil toPythonBoolean equals: false.
	self assert: (TSNode new) toPythonBoolean equals: true.
]
