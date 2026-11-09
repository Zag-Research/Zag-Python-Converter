"
I am a block closure that supports break and continue.
"
Class {
	#name : 'BreakableBlockClosure',
	#superclass : 'Object',
	#instVars : [
		'iterateBlock',
		'breakBlock',
		'continueBlock'
	],
	#category : 'Zag-PythonFeatures-Control Flow',
	#package : 'Zag-PythonFeatures',
	#tag : 'Control Flow'
}

{ #category : 'actions' }
BreakableBlockClosure >> break [
	"Ends my loop immediately."
	self breakBlock value
]

{ #category : 'accessing' }
BreakableBlockClosure >> breakBlock [
	"The block that, when evaluated, breaks."
	^ breakBlock
]

{ #category : 'accessing' }
BreakableBlockClosure >> breakBlock: anObject [

	breakBlock := anObject
]

{ #category : 'actions' }
BreakableBlockClosure >> continue [
	"Ends this iteration of the loop, resuming at the start of the next one."
	self continueBlock value
]

{ #category : 'accessing' }
BreakableBlockClosure >> continueBlock [
	"The block that, when evaluated, continues."
	^ continueBlock
]

{ #category : 'accessing' }
BreakableBlockClosure >> continueBlock: anObject [

	continueBlock := anObject
]

{ #category : 'accessing' }
BreakableBlockClosure >> iterateBlock [
	"The block that I evaluate for my loop."
	^ iterateBlock
]

{ #category : 'accessing' }
BreakableBlockClosure >> iterateBlock: anObject [

	iterateBlock := anObject
]

{ #category : 'evaluating' }
BreakableBlockClosure >> value [
	"Evaluate my iteration block with no argument."
	self continueBlock: [ ^nil ].
	self iterateBlock value: self.
]

{ #category : 'evaluating' }
BreakableBlockClosure >> value: anObject [
	"Evaluate my iteration block with the provided value."
	self continueBlock: [ ^nil ].
	self iterateBlock value: anObject value: self.
]
