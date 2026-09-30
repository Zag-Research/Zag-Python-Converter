Extension { #name : 'ArrayedCollection' }

{ #category : '*Zag-PythonFeatures' }
ArrayedCollection >> immutableView [
	^ConstantArray new backingArray: self
]
