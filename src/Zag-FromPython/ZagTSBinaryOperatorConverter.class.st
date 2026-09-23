"
I am the ZagTSConverter for binary operators.
"
Class {
	#name : 'ZagTSBinaryOperatorConverter',
	#superclass : 'ZagTSOperatorConverter',
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'converting - special cases' }
ZagTSBinaryOperatorConverter class >> booleanToZagAST: op left: leftChild right: rightChild [
	| zagSelector |
	zagSelector := { #and -> #pythonAnd:. #or -> #pythonOr: } asDictionary
		at: op ifAbsent: [ self error: 'Invalid operator for booleanToZagAST:.' ].
	^ ASSend
		  target: leftChild asZagASTNode
		  selector: zagSelector
		  args: { (ASBlockNode arguments: #() locals: #() body: { rightChild asZagASTNode }) }
]

{ #category : 'converting' }
ZagTSBinaryOperatorConverter class >> convertToZagASTSelector: aSymbol left: leftChild right: rightChild [
	^self specialCaseMap
		at: aSymbol
		ifPresent: [ :selector | self perform: selector with: aSymbol with: leftChild with: rightChild ]
		ifAbsent: [ self zagOperatorASTFromSelector: (self pythonToZagOperatorMap at: aSymbol) children: { leftChild . rightChild } ].
]

{ #category : 'converting - special cases' }
ZagTSBinaryOperatorConverter class >> inToZagAST: op left: leftChild right: rightChild [
	^ASSend target: rightChild asZagASTNode selector: #includes: args: {leftChild asZagASTNode}
]

{ #category : 'converting - special cases' }
ZagTSBinaryOperatorConverter class >> notInToZagAST: op left: leftChild right: rightChild [
	^ASSend target: (ASSend target: rightChild asZagASTNode selector: #includes: args: {
		leftChild asZagASTNode}) selector: #not args: #()
]

{ #category : 'class initialization' }
ZagTSBinaryOperatorConverter class >> putRules: aClass [
	aClass at: #binary_operator putRule: self new.
	aClass at: #comparison_operator putRule: self new.
	aClass at: #boolean_operator putRule: self new.
]

{ #category : 'constants' }
ZagTSBinaryOperatorConverter class >> pythonToZagOperatorMap [
	"Returns a dictionary mapping Python operators to Zag selectors.  Excludes special cases"
	| map |
	map := {
		#** -> #raisedTo:. #'^' -> #bitXor:. #<< -> #bitShift:.
		#== -> #=. #!= -> #~=. #is -> #==. #'is not' -> #~~.
	} asDictionary.
	#(#+ #- #* #/ #// #% #& #| #< #<= #> #>=) do: [ :each | map at: each put: each ].
	^map
]

{ #category : 'converting - special cases' }
ZagTSBinaryOperatorConverter class >> rightShiftToZagAST: op left: leftChild right: rightChild [
	^ASSend target: leftChild asZagASTNode selector: #bitShift: args: {
			ASSend target: rightChild asZagASTNode selector: #negated args: #() }
]

{ #category : 'constants' }
ZagTSBinaryOperatorConverter class >> specialCaseMap [
	"Returns a list of special cases, mapping Python operator names to methods used to convert them."
	^{
		#and -> #booleanToZagAST:left:right:. #or -> #booleanToZagAST:left:right:.
		#>> -> #rightShiftToZagAST:left:right:.
		#in -> #inToZagAST:left:right:.
		#'not in' -> #notInToZagAST:left:right: 
	} asDictionary
]

{ #category : 'converting' }
ZagTSBinaryOperatorConverter >> convertToZagAST: aZagTSNode [
	^self class convertToZagASTSelector: (self pythonOperator: aZagTSNode) left: aZagTSNode >> 1 right: aZagTSNode >> 2
]

{ #category : 'converting' }
ZagTSBinaryOperatorConverter >> pythonOperator: aZagTSNode [
	"Returns the Python operator name corresponding to this ZagTSNode."
	^aZagTSNode getBinaryOperator
]
