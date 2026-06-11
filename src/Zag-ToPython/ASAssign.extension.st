Extension { #name : 'ASAssign' }

{ #category : '*Zag-ToPython' }
ASAssign >> asPythonSource [
	^self variable asPythonSource,' = ',self expression asPythonSource.
]
