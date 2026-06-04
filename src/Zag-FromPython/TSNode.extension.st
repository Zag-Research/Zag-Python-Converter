Extension { #name : 'TSNode' }

{ #category : '*Zag-FromPython' }
TSNode >> hasErrorDescendant [
	"Returns true iff I have an error node.  Checks all descendants."
	^self isErrorNode or: [ self collectNamedChild anySatisfy: #hasErrorDescendant ]
]
