Class {
	#name : 'ZagToPythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-ToPython-Tests-Tests',
	#package : 'Zag-ToPython-Tests',
	#tag : 'Tests'
}

{ #category : 'asserting' }
ZagToPythonConversionTest >> assert: ast convertsTo: source [
	"Assert the provided Zag AST converts to the provided Python source."
	| actual |
	actual := ZagToPythonVisitor astToPythonSource: ast.
	self assert: source equals: actual.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testAddition [
	"Tests converting a simple addition expression."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #+ args: { ASLiteral literal: 3 }.
	expected := '2 + 3'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testAdditionMultiplication [
	"Tests converting a simple addition-multiplication expression, which does not require parentheses."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #+ args: {
		ASSend target: (ASLiteral literal: 3) selector: #* args: { ASLiteral literal: 4 }
	}.
	expected := '2 + 3 * 4'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - arrays' }
ZagToPythonConversionTest >> testArrayAccess [
	"Test converting accessing an array element using at:."
	| ast expected |
	ast := ASSend target: (ASRef variable: #a) selector: #at: args: { ASRef variable: #i }.
	expected := 'a[i - 1]'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - arrays' }
ZagToPythonConversionTest >> testArrayPut [
	"Test converting setting an array element using at:put:."
	| ast expected |
	ast := ASSend target: (ASRef variable: #a) selector: #at:put: args: { ASRef variable: #i . ASRef variable: #v }.
	expected := 'a[i - 1] = v'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - basic expressions' }
ZagToPythonConversionTest >> testAssign [
	"Test that an ASAssign converts correctly."
	| ast expected |
	ast := ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 1).
	expected := 'x = 1'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testAssociativeAddition1 [
	"Tests converting a simple 3-argument addition expression."
	"The brackets here aren't necessary, but would only arise if the user specifically put them there."
	"Therefore, I am allowing them to be included or omitted."
	| ast expected1 expected2 actual |
	ast := ASSend target: (ASLiteral literal: 2) selector: #+ args: {
		ASSend target: (ASLiteral literal: 3) selector: #+ args: { ASLiteral literal: 4 } }.
	expected1 := '2 + (3 + 4)'.  expected2 := '2 + 3 + 4'.
	actual := ZagToPythonVisitor astToPythonSource: ast.
	self assert: ({ expected1. expected2 } includes: actual).
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testAssociativeAddition2 [
	"Tests converting a simple 3-argument addition expression."
	| ast expected |
	ast := ASSend target: (
		ASSend target: (ASLiteral literal: 2) selector: #+ args: { ASLiteral literal: 3 })
	selector: #+ args: { ASLiteral literal: 4 }.
	expected := '2 + 3 + 4'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testMultiplicationAddition [
	"Tests converting a simple addition-multiplication expression, which requires brackets."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #* args: {
		ASSend target: (ASLiteral literal: 3) selector: #+ args: { ASLiteral literal: 4 }
	}.
	expected := '2 * (3 + 4)'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - basic expressions' }
ZagToPythonConversionTest >> testStringLiteral [
	"Test that string literals convert properly."
	| ast expected |
	ast := ASLiteral literal: 'Hello, world!'.
	expected := '"Hello, world!"'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testTripleSubtraction1 [
	"Tests converting a simple 3-argument subtraction expression."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #- args: {
		ASSend target: (ASLiteral literal: 3) selector: #- args: { ASLiteral literal: 4 } }.
	expected := '2 - (3 - 4)'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testTripleSubtraction2 [
	"Tests converting a simple 3-argument subtraction expression."
	| ast expected |
	ast := ASSend target: (
		ASSend target: (ASLiteral literal: 2) selector: #- args: { ASLiteral literal: 3 })
	selector: #- args: { ASLiteral literal: 4 }.
	expected := '2 - 3 - 4'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - arrays' }
ZagToPythonConversionTest >> testZWArrayAccess [
	"Test converting accessing an array element using zwAt:."
	| ast expected |
	ast := ASSend target: (ASRef variable: #a) selector: #zwAt: args: { ASRef variable: #i }.
	expected := 'a[i]'.
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - arrays' }
ZagToPythonConversionTest >> testZWArrayPut [
	"Test converting setting an array element using zwAt:put:."
	| ast expected |
	ast := ASSend target: (ASRef variable: #a) selector: #zwAt:put: args: { ASRef variable: #i . ASRef variable: #v }.
	expected := 'a[i] = v'.
	self assert: ast convertsTo: expected.
]
