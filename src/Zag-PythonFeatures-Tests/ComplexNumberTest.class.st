Class {
	#name : 'ComplexNumberTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests',
	#package : 'Zag-PythonFeatures-Tests'
}

{ #category : 'tests' }
ComplexNumberTest >> testInstantiationAccessing [
	"Tests that you can instantiate a complex number and access its variables"
	| c |
	c := ComplexNumber real: 1 imag: 2.
	self assert: c realPart equals: 1.
	self assert: c imaginaryPart equals: 2.
]
