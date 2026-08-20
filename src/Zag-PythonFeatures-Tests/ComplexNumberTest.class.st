Class {
	#name : 'ComplexNumberTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests',
	#package : 'Zag-PythonFeatures-Tests'
}

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testConjugate [
	self assert: (1 + 0i) conjugate equals: 1 + 0i.
	self assert: (2 + 1i) conjugate equals: 2 - 1i.
	self assert: (2 - 1i) conjugate equals: 2 + 1i.
	
	{ 1 + 0i . 2 + 1i . 1 - 2i } do: [ :each |
		self assert: each + each conjugate equals: 2 * each realPart + 0i.
		self assert: each * each conjugate equals: each realPart squared + each imaginaryPart squared + 0i.
	]
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testDivision [
	self assert: (3 + 4i) / 2i equals: 2 - 1.5i.
	self assert: (5 + 10i) / (3 - 4i) equals: -1 + 2i.
	self assert: 1 / 1i equals: -1i.
]

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
ComplexNumberTest >> testLiterals [
	"Ensure that complex literals work in the same way as directly-created complex numbers."
	| c1 c2 |
	c1 := 1 + 2i.
	c2 := ComplexNumber real: 1 imag: 2.
	self assert: c1 equals: c2.
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testMinus [
	self assert: (1 + 2i) - (2 + 1i) equals: (-1 + 1i).
	self assert: (-1 + 1i) - (1 - 1i) equals: (-2 + 2i).
	self assert: (-1 + 0i) - (-2 + 1i) equals: (1 - 1i).
	self assert: (1 + 0.5i) - (6 - 4i) equals: (-5 + 4.5i).
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testNegated [
	self assert: (1 + 1i) negated equals: -1 - 1i.
	self assert: 0i negated equals: 0i.
	self assert: (1 - 1i) negated equals: -1 + 1i.
]

{ #category : 'tests' }
ComplexNumberTest >> testNotEqual [
	| c1 c2 |
	c1 := ComplexNumber real: 1 imag: 2.
	c2 := ComplexNumber real: 2 imag: 1.
	self deny: c1 equals: c2.
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testPlus [
	self assert: (1 + 2i) + (2 + 1i) equals: (3 + 3i).
	self assert: (-1 + 1i) + (1 - 1i) equals: (0 + 0i).
	self assert: (-1 + 0i) + (-2 + 1i) equals: (-3 + 1i).
	self assert: (1 + 0.5i) + (6 - 4i) equals: (7 - 3.5i).
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testTimes [
	self assert: 1i * 1i equals: -1 + 0i.
	self assert: 1i * -1i equals: 1 + 0i.
	self assert: (1 + 1i) * (1 + 1i) equals: 2i.
	self assert: (1 + 1i) * (1 - 1i) equals: 2 + 0i.
	self assert: (-1 + 3i) * (2 - 4i) equals: 10 + 10i.
]

{ #category : 'tests - arithmetic' }
ComplexNumberTest >> testZeroDivision [
	self should: [ 1i / 0 ] raise: ZeroDivide.
	self should: [ 1 / 0i ] raise: ZeroDivide.
	self should: [ 1i / 0i ] raise: ZeroDivide.
]
