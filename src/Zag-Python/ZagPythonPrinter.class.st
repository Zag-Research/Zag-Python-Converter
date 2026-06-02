"
I am a visitor that can be used to print ZagPythonAST subclasses.
"
Class {
	#name : 'ZagPythonPrinter',
	#superclass : 'ZagPythonVisitor',
	#instVars : [
		'stream'
	],
	#category : 'Zag-Python-AST',
	#package : 'Zag-Python',
	#tag : 'AST'
}

{ #category : 'accessing' }
ZagPythonPrinter >> stream [
	^stream
]

{ #category : 'accessing' }
ZagPythonPrinter >> stream: aStream [
	stream := aStream
]

{ #category : 'visiting' }
ZagPythonPrinter >> visitAssignmentNode: anAssign [
	"Prints the provided assignment onto my stream."
	stream
		print: anAssign class;
		nextPutAll: '['.
	self visit: anAssign variable.
	stream nextPutAll: '='.
	self visit: anAssign expression.
	stream nextPutAll: ']'.
]

{ #category : 'visiting' }
ZagPythonPrinter >> visitLiteral: aLiteral [
	"Prints the provided literal onto my stream."
	stream
		print: aLiteral class;
		nextPutAll: '[';
		print: aLiteral literal;
		nextPutAll: ']'
]

{ #category : 'visiting' }
ZagPythonPrinter >> visitRef: aRef [
	"Prints the provided literal onto my stream."
	stream
		print: aRef class;
		nextPutAll: '[';
		print: aRef variable;
		nextPutAll: ']'
]
