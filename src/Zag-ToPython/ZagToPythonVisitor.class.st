"
I am a visitor that can be used to convert Zag ASTs into Python source code.
"
Class {
	#name : 'ZagToPythonVisitor',
	#superclass : 'Object',
	#instVars : [
		'resultStream'
	],
	#category : 'Zag-ToPython',
	#package : 'Zag-ToPython'
}

{ #category : 'converting' }
ZagToPythonVisitor class >> astToPythonSource: anAST [
	"Convert a Zag AST to Python source code."
	^String streamContents: [ :stream | self new resultStream: stream; visit: anAST ]
]

{ #category : 'accessing' }
ZagToPythonVisitor >> resultStream [
	"Gets my result stream."
	^resultStream
]

{ #category : 'setting' }
ZagToPythonVisitor >> resultStream: aStream [
	"Sets my result stream."
	resultStream := aStream
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visit: anAST [
	"Accepts an AST, and prints its corresponding Python source to my result stream."
	^anAST accept: self
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitAssign: anAssign [
	"Visits an ASAssign, adding its associated Python source to my stream."
	self visit: anAssign variable.
	resultStream nextPutAll: ' = '.
	self visit: anAssign expression.
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitLiteral: aLiteral [
	"Visits an ASLiteral, adding its associated Python source to my stream."
	aLiteral literal isString
		ifTrue: [
			resultStream nextPut: $".
			resultStream nextPutAll: aLiteral literal.
			resultStream nextPut: $".
		] ifFalse: [ resultStream nextPutAll: aLiteral literal asString ]
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitRef: aRef [
	"Visits an ASRef, adding its associated Python source to my stream."
	resultStream nextPutAll: aRef variable asString
]
