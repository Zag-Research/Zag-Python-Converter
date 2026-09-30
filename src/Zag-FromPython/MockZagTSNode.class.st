"
I am a mock ZagTSNode whose #asZagASTNode message returns a precomputed Zag AST.

I am used for helper methods that expect a ZagTSNode, but where only a Zag AST is available.

"
Class {
	#name : 'MockZagTSNode',
	#superclass : 'Object',
	#instVars : [
		'zagAST'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'converting' }
MockZagTSNode >> asZagASTNode [
	^self zagAST
]

{ #category : 'accessing' }
MockZagTSNode >> zagAST [

	^ zagAST
]

{ #category : 'accessing' }
MockZagTSNode >> zagAST: anObject [

	zagAST := anObject
]
