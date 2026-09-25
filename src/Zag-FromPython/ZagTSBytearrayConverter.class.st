"
I am the ZagTSBuiltinConverter for bytearray().
"
Class {
	#name : 'ZagTSBytearrayConverter',
	#superclass : 'ZagTSBuiltinConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSBytearrayConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	aClass at: #bytearray putBuiltinRule: self new
]

{ #category : 'converting' }
ZagTSBytearrayConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	^ASSend target: (ASRef variable: #ByteArray) selector: #fromNumberOrString: args: {
		(aBuiltin >> 2 >> 1) asZagASTNode }
]
