"
I represent an assignment statement in Python.  My 'variable' is an PyRef that contains the variable I am assigning to, and my 'expression' is an expression that contains the value being assigned.
"
Class {
	#name : 'PyAssign',
	#superclass : 'ZagPythonAST',
	#instVars : [
		'variable',
		'expression'
	],
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'instance creation' }
PyAssign class >> variable: aRef expression: anExpression [
	"Creates and returns a new PyAssign with the provided variable and expression."
	^self new variable: aRef;
		expression: anExpression;
		yourself
]

{ #category : 'visiting' }
PyAssign >> accept: aVisitor [
	^aVisitor visitAssignmentNode: self.
]

{ #category : 'accessing' }
PyAssign >> expression [
	"Returns the expression this assignment is assigning."
	^expression
]

{ #category : 'accessing' }
PyAssign >> expression: anExpression [
	"Sets the expression this assignment is assigning."
	expression := anExpression
]

{ #category : 'accessing' }
PyAssign >> variable [
	"Returns the variable this object is assigning to"
	^variable
]

{ #category : 'accessing' }
PyAssign >> variable: aRef [
	"Sets the variable this object is assigning to"
	variable := aRef
]
