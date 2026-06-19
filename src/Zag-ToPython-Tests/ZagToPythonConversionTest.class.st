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
	expected := '(2) + (3)'. "TODO remove unnecessary parentheses"
	self assert: ast convertsTo: expected.
]

{ #category : 'tests - operations' }
ZagToPythonConversionTest >> testAdditionMultiplication [
	"Tests converting a simple addition-multiplication expression, which does not require parentheses."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #+ args: {
		ASSend target: (ASLiteral literal: 3) selector: #* args: { ASLiteral literal: 4 }
	}.
	expected := '(2) + ((3) * (4))'. "TODO remove unnecessary parentheses"
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
ZagToPythonConversionTest >> testMultiplicationAddition [
	"Tests converting a simple addition-multiplication expression, which requires brackets."
	| ast expected |
	ast := ASSend target: (ASLiteral literal: 2) selector: #* args: {
		ASSend target: (ASLiteral literal: 3) selector: #+ args: { ASLiteral literal: 4 }
	}.
	expected := '(2) * ((3) + (4))'. "TODO remove unnecessary parentheses"
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
