Class {
	#name : 'ComplexNumberTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests',
	#package : 'Zag-PythonFeatures-Tests'
}

{ #category : 'tests' }
ComplexNumberTest >> testEqual [
	| c1 c2 |
	c1 := ComplexNumber real: 1 imag: 2.
	c2 := ComplexNumber real: 1 imag: 2.
	self assert: c1 equals: c2.
	self assert: c1 hash equals: c2 hash.
]

{ #category : 'tests' }
ComplexNumberTest >> testInstantiationAccessing [
	"Tests that you can instantiate a complex number and access its variables"
	| c |
	c := ComplexNumber real: 1 imag: 2.
	self assert: c realPart equals: 1.
	self assert: c imaginaryPart equals: 2.
]

{ #category : 'tests' }
ComplexNumberTest >> testNotEqual [
	| c1 c2 |
	c1 := ComplexNumber real: 1 imag: 2.
	c2 := ComplexNumber real: 2 imag: 1.
	self assert: c1 ~= c2.
]
