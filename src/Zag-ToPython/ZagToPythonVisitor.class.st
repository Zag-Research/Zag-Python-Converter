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

{ #category : 'constants' }
ZagToPythonVisitor class >> smalltalkToPythonOperations [
	"Returns a dictionary mapping Smalltalk operands to Python."
	^{ 
		#+ -> #+.
		#- -> #-.
		#* -> #*.
		#/ -> #/.
	} asDictionary.
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
ZagToPythonVisitor >> visitCascade: aCascade [
	"Visits an ASCascade, adding its associated Python source to my stream."
	aCascade collect: [ :send | send target: aCascade target ] thenDo: [ :each | self visit: each ]
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

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitOperation: aSend [
	"Like visitSend, but the selector is in smalltalkToPythonOperations."
	resultStream nextPut: $(.
	aSend target accept: self.
	resultStream nextPutAll: ') '.
	resultStream nextPutAll: (self class smalltalkToPythonOperations at: aSend selector).
	resultStream nextPutAll: ' ('.
	aSend args first accept: self.
	resultStream nextPut: $).
	
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitRef: aRef [
	"Visits an ASRef, adding its associated Python source to my stream."
	resultStream nextPutAll: aRef variable asString
]

{ #category : 'visiting' }
ZagToPythonVisitor >> visitReturn: aReturn [
	"Visits an ASReturn, adding its associated Python source to my stream."
	resultStream nextPutAll: 'return '.
	self visit: aReturn expression.
]

{ #category : 'visiting - message sends' }
ZagToPythonVisitor >> visitSend: aSend [
	"Prints a send operation to my stream."
	{
		[ self class smalltalkToPythonOperations includesKey: aSend selector ] -> [ self visitOperation: aSend ].
	} switch.
]
