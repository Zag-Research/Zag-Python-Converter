Extension { #name : 'ByteArray' }

{ #category : '*Zag-PythonFeatures' }
ByteArray class >> fromNumberOrString: aValue [
	"If aValue is a number, return self new: aValue.  If it's a collection, return aValue asByteArray."
	aValue isInteger ifTrue: [ ^self new: aValue ].
	aValue isCollection ifTrue: [ ^aValue asByteArray ].
	self error: 'Unrecognized type of aValue'.
]
