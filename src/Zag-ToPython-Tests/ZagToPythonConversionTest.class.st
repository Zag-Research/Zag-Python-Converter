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

{ #category : 'tests - basic expressions' }
ZagToPythonConversionTest >> testAssign [
	"Test that an ASAssign converts correctly."
	| ast expected |
	ast := ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 1).
	expected := 'x = 1'.
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
