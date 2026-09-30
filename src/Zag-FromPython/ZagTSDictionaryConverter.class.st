"
I am the ZagTSConverter for dictionary literals.
"
Class {
	#name : 'ZagTSDictionaryConverter',
	#superclass : 'ZagTSCollectionConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSDictionaryConverter class >> putRules: aClass [
	aClass at: #dictionary putRule: (self new conversionSelector: #asDictionary)
]

{ #category : 'converting' }
ZagTSDictionaryConverter >> convertChild: aChild [
	"Convert one element of this collection to Zag"
	^ASSend
		target: (aChild >> 1) asZagASTNode
		selector: #->
		args: { (aChild >> 2) asZagASTNode }
]
