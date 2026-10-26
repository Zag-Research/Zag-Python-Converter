"
Ensures the +, operator works as intended.
"
Class {
	#name : 'AddConcatTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Basic Types',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Basic Types'
}

{ #category : 'tests' }
AddConcatTest >> testArrays [
	self assert: #(#a) +, #(#b #c) +, #(#d #e #f) equals: #(#a #b #c #d #e #f)
]

{ #category : 'tests' }
AddConcatTest >> testComplexNumbers [
	self assert: 1 +, 2i +, 3 +, 4i equals: 4 + 6i
]

{ #category : 'tests' }
AddConcatTest >> testNumbers [
	self assert: 2 +, 3 +, 4 equals: 9
]

{ #category : 'tests' }
AddConcatTest >> testStrings [
	self assert: 'a' +, 'b' +, 'c' +, 'd' equals: 'abcd'
]
