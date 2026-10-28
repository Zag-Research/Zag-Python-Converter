"
I am the ZagTSConverter for the try statement
"
Class {
	#name : 'ZagTSTryConverter',
	#superclass : 'ZagTSConverter',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'class initialization' }
ZagTSTryConverter class >> putRules: aClass [
	"Add all of my conversion rules to aClass using its at:putRule: message."
	"This message will be called once for each subclass of ZagSendConverter on initialization."
	aClass at: #try_statement putRule: self new
]

{ #category : 'converting' }
ZagTSTryConverter >> convertToZagAST: aZagTSNode [
	(aZagTSNode >> 2) childrenCount > 1
		ifFalse: [ ^ASSend
			target: (aZagTSNode >> 1) asZagASTNode
			selector: #onErrorDo:
			args: { (aZagTSNode >> 2 >> 1) asZagASTNode } ]
		ifTrue: [ ^ASSend
			target: (aZagTSNode >> 1) asZagASTNode
			selector: #on:do:
			args: { (aZagTSNode >> 2 >> 1 >> 1) asZagASTNode.
				ASBlockNode
					arguments: { (aZagTSNode >> 2 >> 1 >> 2 >> 1) asZagASTNode } locals: #()
					body: (aZagTSNode >> 2 >> 2) asZagASTNode body } ]
]
