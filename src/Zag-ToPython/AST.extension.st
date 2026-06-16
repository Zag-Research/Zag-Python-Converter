Extension { #name : 'AST' }

{ #category : '*Zag-ToPython' }
AST >> asPythonSource [
	^ZagToPythonVisitor astToPythonSource: self
]
