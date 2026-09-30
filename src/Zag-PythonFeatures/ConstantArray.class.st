"
I am an immutable view of my backing collection.  My mutation methods do not work.  I will still reflect any changes to my backing array.
"
Class {
	#name : 'ConstantArray',
	#superclass : 'ArrayedCollection',
	#instVars : [
		'backingArray'
	],
	#category : 'Zag-PythonFeatures-Basic Types',
	#package : 'Zag-PythonFeatures',
	#tag : 'Basic Types'
}

{ #category : 'accessing' }
ConstantArray >> at: anIndex [
	^backingArray at: anIndex
]

{ #category : 'accessing' }
ConstantArray >> at: index put: anObject [
	self shouldNotImplement
]

{ #category : 'private - initialization' }
ConstantArray >> backingArray: anArray [
	backingArray
		ifNil: [ backingArray := anArray ]
		ifNotNil: [ self error: 'Backing array is already set.' ]
]

{ #category : 'accessing' }
ConstantArray >> backingArrayCopy [
	"Returns a copy of by backing array."
	^backingArray copy
]

{ #category : 'accessing' }
ConstantArray >> size [
	^backingArray size
]
