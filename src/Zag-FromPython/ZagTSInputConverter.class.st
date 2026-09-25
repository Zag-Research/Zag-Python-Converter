"
I am the ZagTSBuiltinConverter for input().
"
Class {
	#name : 'ZagTSInputConverter',
	#superclass : 'ZagTSBuiltinConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSInputConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	aClass at: #input putBuiltinRule: self new
]

{ #category : 'converting' }
ZagTSInputConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	^ASSend
		target: (ASSend target: (ASRef variable: #UIManager) selector: #default args: #())
		selector: #request:
		args: { (aBuiltin >> 2 >> 1) asZagASTNode }.
]
