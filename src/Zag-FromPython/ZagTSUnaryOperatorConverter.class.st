"
I am the ZagTSConverter for unary operators.
"
Class {
	#name : 'ZagTSUnaryOperatorConverter',
	#superclass : 'ZagTSOperatorConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'class initialization' }
ZagTSUnaryOperatorConverter class >> putRules: aClass [
	aClass at: #unary_operator putRule: self new.
	aClass at: #not_operator putRule: self new.
]

{ #category : 'constants' }
ZagTSUnaryOperatorConverter class >> pythonToZagOperatorMap [
	"A dictionary mapping Python operators to Zag operators."
	^{
		#not -> #pythonNot.
		#- -> #negated.
		#~ -> #bitInvert.
	} asDictionary
]

{ #category : 'converting' }
ZagTSUnaryOperatorConverter >> pythonOperator: aZagTSNode [
	"Returns the Python operator name corresponding to this ZagTSNode."
	^aZagTSNode getUnaryOperator
]
