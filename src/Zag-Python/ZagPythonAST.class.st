"
My subclasses and I make up the Zag Python AST.
"
Class {
	#name : 'ZagPythonAST',
	#superclass : 'Object',
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'visiting' }
ZagPythonAST >> accept: aVisitor [
	"Sends aVisitor the visit___ message, based on which subclass I am."
	self subclassResponsibility
]

{ #category : 'printing' }
ZagPythonAST >> printOn: aStream [
	ZagPythonPrinter new stream: aStream; visit: self.
]
