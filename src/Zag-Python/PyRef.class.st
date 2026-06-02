"
I represent a reference to a variable in Python.  My 'variable' slot contains my variable's name, as a symbol.
"
Class {
	#name : 'PyRef',
	#superclass : 'ZagPythonAST',
	#instVars : [
		'variable'
	],
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'accessing' }
PyRef class >> variable: aSymbol [
	"Creates and returns a PyRef with the provided variable name."
	^self new variable: aSymbol; yourself
]

{ #category : 'visiting' }
PyRef >> accept: aVisitor [
	^aVisitor visitRef: self.
]

{ #category : 'accessing' }
PyRef >> variable [
	"The name of the variable I represent, as a symbol."
	^variable
]

{ #category : 'accessing' }
PyRef >> variable: aSymbol [
	"Set the name of the variable I represent; must be a symbol."
	variable := aSymbol
]
