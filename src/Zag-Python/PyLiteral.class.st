"
I represent a literal value in Python.  My variable 'literal' contains the value I represent.
"
Class {
	#name : 'PyLiteral',
	#superclass : 'ZagPythonAST',
	#instVars : [
		'literal'
	],
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'accessing' }
PyLiteral class >> literal: aValue [
	"Creates and returns a new PyLiteral with the provided value as its literal."
	^self new literal: aValue; yourself
]

{ #category : 'visiting' }
PyLiteral >> accept: aVisitor [
	^aVisitor visitLiteral: self.
]

{ #category : 'accessing' }
PyLiteral >> literal [
	"Returns the value I represent."
	^literal
]

{ #category : 'accessing' }
PyLiteral >> literal: aValue [
	"Sets the value I represent."
	literal := aValue
]
