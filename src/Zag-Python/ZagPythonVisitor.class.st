"
I am a visitor that can visit a ZagPythonAST.
"
Class {
	#name : 'ZagPythonVisitor',
	#superclass : 'Object',
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'visiting' }
ZagPythonVisitor >> visit: anAST [
	anAST accept: self
]

{ #category : 'visiting' }
ZagPythonVisitor >> visitAssignmentNode: aNode [
	self subclassResponsibility
]

{ #category : 'visiting' }
ZagPythonVisitor >> visitLiteral: aLiteral [
	self subclassResponsibility.
]

{ #category : 'visiting' }
ZagPythonVisitor >> visitRef: aRef [
	self subclassResponsibility
]
