"
A test case ensuring that I've ported Python's array index semantics properly with the zwAt: family of messages.
"
Class {
	#name : 'PythonArrayTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Collections',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Collections'
}

{ #category : 'tests' }
PythonArrayTest >> testEndCopy [
	"Tests copying to the special #end symbol."
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwCopyFrom: 2 to: #end.
	self assert: result equals: #(#c #d #e #f).
]

{ #category : 'tests' }
PythonArrayTest >> testMixedIndexCopy [
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwCopyFrom: 1 to: -2.
	self assert: result equals: #(#b #c #d).
]

{ #category : 'tests' }
PythonArrayTest >> testNegativeIndexAccess [
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwAt: -4.
	self assert: result equals: #c.
]

{ #category : 'tests' }
PythonArrayTest >> testNegativeIndexCopy [
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwCopyFrom: -5 to: -2.
	self assert: result equals: #(#b #c #d).
]

{ #category : 'tests' }
PythonArrayTest >> testNegativeIndexSet [
	| arr |
	arr := #(#a #b #c #d #e #f) asOrderedCollection.
	arr zwAt: -4 put: #cc.
	self assert: arr equals: #(#a #b #cc #d #e #f) asOrderedCollection.
]

{ #category : 'tests' }
PythonArrayTest >> testPositiveIndexAccess [
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwAt: 2.
	self assert: result equals: #c.
]

{ #category : 'tests' }
PythonArrayTest >> testPositiveIndexCopy [
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwCopyFrom: 1 to: 4.
	self assert: result equals: #(#b #c #d).
]

{ #category : 'tests' }
PythonArrayTest >> testPositiveIndexSet [
	| arr |
	arr := #(#a #b #c #d #e #f) asOrderedCollection.
	arr zwAt: 2 put: #cc.
	self assert: arr equals: #(#a #b #cc #d #e #f) asOrderedCollection.
]

{ #category : 'tests' }
PythonArrayTest >> testStepCopyEven [
	"Tests copying to the special #end symbol."
	| arr result |
	arr := #(#a #b #c #d #e #f).
	result := arr zwCopyFrom: 0 to: #end by: 2.
	self assert: result equals: #(#a #c #e).
]

{ #category : 'tests' }
PythonArrayTest >> testStepCopyOdd [
	"Tests copying to the special #end symbol."
	| arr result |
	arr := #(#a #b #c #d #e #f #g).
	result := arr zwCopyFrom: 0 to: #end by: 2.
	self assert: result equals: #(#a #c #e #g).
]
