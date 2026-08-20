Class {
	#name : 'ComplexNumberTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests',
	#package : 'Zag-PythonFeatures-Tests'
}

{ #category : 'tests - mathematical functions' }
ComplexNumberTest >> testAbs [
	{ 3 + 4i . 3 - 4i . -3 + 4i . -3 - 4i . 4 + 3i . 4 - 3i . -4 + 3i . -4 - 3i } do: [ :each |
		self assert: each abs equals: 5
	].
	{ 1 + 1i . 1 - 1i . -1 + 1i . -1 - 1i } do: [ :each | self assert: each abs equals: 2 sqrt ].
	{ 3 + 0i . -3 + 0i . 3i . -3i } do: [ :each | self assert: each abs equals: 3 ].
]

{ #category : 'tests - mathematical functions' }
ComplexNumberTest >> testArgument [
	"x -> y means that arg(x) should = y * tau"
	{
		0 + 0i -> 0.
		1 + 0i -> 0.
		0.75 sqrt + 0.5 i -> (1/12).
		0.5 sqrt + 0.5 sqrt i -> (1/8).
		0.5 + 0.75 sqrt i -> (1/6).
		1.0i -> (1/4).
		-0.5 + 0.75 sqrt i -> (1/3).
		-1.0 + 0.0i -> (1/2).
		-1.0i -> (-1/4).
	} do: [ :each |
		self assert: each key argument closeTo: each value * Float twoPi.
		self assert: (each key * 2) argument closeTo: each key argument.
		
	].
]

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

{ #category : 'tests - mathematical functions' }
ComplexNumberTest >> testExp [
	"x -> y means that exp(x tau i) should = y"
	{
		0 -> (1.0 + 0.0i).
		1/12 -> (0.75 sqrt + 0.5i).
		1/8 -> (0.5 sqrt + 0.5 sqrt i).
		1/6 -> (0.5 + 0.75 sqrt i).
		1/4 -> 1.0i.
		1/3 -> (-0.5 + 0.75 sqrt i).
		1/2 -> (-1.0 + 0.0i).
		3/4 -> -1.0i.
		1 -> (1.0 + 0.0i).
	} do: [ :each | self assert: (each key * Float twoPi) i exp closeTo: each value ].
	
	"x -> y means that exp(x) should = y"
	{ 
		0 + 0i -> (1 + 0i).
		1 + 0i -> (1 exp + 0i).
		-1 + 0i -> (-1 exp + 0i).
		0 + (Float twoPi / 4)i -> (0 + 1i).
		1 + (Float twoPi / 4)i -> (0 + 1 exp i).
		-1 + (Float twoPi / 4)i -> (0 + -1 exp i).
		0 - (Float twoPi / 4)i -> (0 - 1i).
		1 - (Float twoPi / 4)i -> (0 - 1 exp i).
		-1 - (Float twoPi / 4)i -> (0 - -1 exp i).
	} do: [ :each | self assert: each key exp closeTo: each value ].
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

{ #category : 'tests - mathematical functions' }
ComplexNumberTest >> testLn [
	"x -> y means that ln(y) should = x tau i"
	{
		0 -> (1.0 + 0.0i).
		1/12 -> (0.75 sqrt + 0.5i).
		1/8 -> (0.5 sqrt + 0.5 sqrt i).
		1/6 -> (0.5 + 0.75 sqrt i).
		1/4 -> 1.0i.
		1/3 -> (-0.5 + 0.75 sqrt i).
		1/2 -> (-1.0 + 0.0i).
		-1/4 -> -1.0i.
	} do: [ :each | self assert: each value ln closeTo: each key * Float twoPi i].
	
	"x -> y means that exp(x) should = y"
	{ 
		0 + 0i -> (1 + 0i).
		1 + 0i -> (1 exp + 0i).
		-1 + 0i -> (-1 exp + 0i).
		0 + (Float twoPi / 4)i -> (0 + 1i).
		1 + (Float twoPi / 4)i -> (0 + 1 exp i).
		-1 + (Float twoPi / 4)i -> (0 + -1 exp i).
		0 - (Float twoPi / 4)i -> (0 - 1i).
		1 - (Float twoPi / 4)i -> (0 - 1 exp i).
		-1 - (Float twoPi / 4)i -> (0 - -1 exp i).
	} do: [ :each | self assert: each value ln closeTo: each key ].
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

{ #category : 'tests - mathematical functions' }
ComplexNumberTest >> testPolarCoordinates [
	"Test that polar and rectangular coordinates return the same numbers."
	
	"(x@y) -> (a@b) means that x + yi should = a exp(b tau i)"
	{
		(0@0) -> (0@0).
		
		(1 @ 0) -> (1 @ 0).
		(0.75 sqrt @ 0.5) -> (1 @ (1/12)).
		(0.5 sqrt @ 0.5 sqrt) -> (1 @ (1/8)).
		(0.5 @ 0.75 sqrt) -> (1 @ (1/6)).
		(0 @ 1) -> (1 @ (1/4)).
		(-0.5 @ 0.75 sqrt) -> (1 @ (1/3)).
		(-1 @ 0) -> (1 @ (1/2)).
		(0 @ -1) -> (1 @ (-1/4)).
		
		(3 @ 4) -> (5 @ ((4 arcTan: 3) / Float twoPi)).
	} do: [ :each | | rectangular polar |
		rectangular := ComplexNumber real: each key x imag: each key y.
		polar := ComplexNumber magnitude: each value x argument: each value y * Float twoPi.
		self assert: polar closeTo: rectangular.
		
		"also test extracting the coordinates"
		self assert: rectangular realPart equals: each key x.
		self assert: rectangular imaginaryPart equals: each key y.
		self assert: rectangular abs closeTo: each value x.
		self assert: rectangular argument closeTo: each value y * Float twoPi.
	]
]

{ #category : 'tests' }
ComplexNumberTest >> testPolarLiterals [
	"Ensure that polar complex numbers made with arithmetic are the same as the constructor."
	| c1 c2 |
	c1 := 2 * (0.35 * Float twoPi) i exp.
	c2 := ComplexNumber magnitude: 2 argument: 0.35 * Float twoPi.
	self assert: c1 equals: c2.
]

{ #category : 'tests' }
ComplexNumberTest >> testRaisedTo [
	self assert: (1i ** 1i) closeTo: 0.207879576351 + 0i
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
