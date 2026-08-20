Extension { #name : 'Number' }

{ #category : '*Zag-PythonFeatures' }
Number >> i [
	"Returns me times i, as a complex number."
	"This is useful for creating complex literals like 1 + 2 i."
	^ComplexNumber real: 0 imag: self
]
