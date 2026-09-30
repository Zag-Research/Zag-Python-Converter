"
I am the ZagTSConverter for set literals.
"
Class {
	#name : 'ZagTSSetConverter',
	#superclass : 'ZagTSCollectionConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSSetConverter class >> putRules: aClass [
	aClass at: #set putRule: (self new conversionSelector: #asSet)
]

{ #category : 'converting' }
ZagTSSetConverter >> convertChild: aChild [
	"Convert one element of this collection to Zag"
	^aChild asZagASTNode
]
