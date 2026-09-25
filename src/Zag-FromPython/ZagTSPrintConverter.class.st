"
I am the ZagTSBuiltinConverter for print()
"
Class {
	#name : 'ZagTSPrintConverter',
	#superclass : 'ZagTSBuiltinConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSPrintConverter class >> putBuiltinRules: aClass [
	"Adds builtin converter rules to this class."
	aClass at: #print putBuiltinRule: self new
]

{ #category : 'converting' }
ZagTSPrintConverter >> convertToZagAST: aBuiltin [
	"Converts the provided builtin call to a Zag AST."
	| calls |
	calls := (aBuiltin >> 2) children collect: [ :each |
		ASSend selector: #show: args: { each asZagASTNode } ].
	^ASCascade target: (ASRef variable: #Transcript) sends: (calls copyWith: (
		ASSend selector: #cr args: #())).
]
