Extension { #name : 'ASLiteral' }

{ #category : '*Zag-ToPython' }
ASLiteral >> asPythonSource [
	^literal isString
		ifTrue: [ '"',literal,'"' ]
		ifFalse: [ literal asString ].
]
