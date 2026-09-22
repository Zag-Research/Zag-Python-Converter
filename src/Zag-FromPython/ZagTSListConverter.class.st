"
I am the ZagTSConverter for list literals.
"
Class {
	#name : 'ZagTSListConverter',
	#superclass : 'ZagTSCollectionConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSListConverter class >> putRules: aClass [
	aClass at: #list putRule: (self new conversionSelector: nil).
]

{ #category : 'converting' }
ZagTSListConverter >> convertChild: aChild [
	"Convert one element of this collection to Zag"
	^aChild asZagASTNode
]
