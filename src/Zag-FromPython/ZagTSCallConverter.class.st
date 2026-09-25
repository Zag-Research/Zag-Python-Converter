"
I am the ZagTSConverter for function calls.
"
Class {
	#name : 'ZagTSCallConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSCallConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #call putRule: self new
]

{ #category : 'converting' }
ZagTSCallConverter >> convertToZagAST: aZagTSNode [
	^(ZagTSBuiltinConverter builtinConverterRules includesKey: (aZagTSNode >> 1) sourcePart asSymbol)
		ifTrue: [ ZagTSBuiltinConverter builtinToZagAST: aZagTSNode ]
		ifFalse: [ self notYetImplemented ]
]
