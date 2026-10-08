Extension { #name : 'Magnitude' }

{ #category : '*Zag-PythonFeatures' }
Magnitude >> isOrdered [
	"Returns true iff I support the comparison operators (<, >, <=, >=).  Non-ordered objects can still implement = and ~=."
	^true
]
