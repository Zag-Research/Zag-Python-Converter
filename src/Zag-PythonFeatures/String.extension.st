Extension { #name : 'String' }

{ #category : '*Zag-PythonFeatures' }
String >> isOrdered [
	"Returns true iff I support the comparison operators (<, >, <=, >=).  Non-ordered objects can still implement = and ~=."
	^true
]
