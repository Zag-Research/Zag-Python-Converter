"
I represent a complex number.

My instance variables store my real and imaginary parts; they can be any instance of Number.
"
Class {
	#name : 'ComplexNumber',
	#superclass : 'Object',
	#instVars : [
		'real',
		'imag'
	],
	#category : 'Zag-PythonFeatures',
	#package : 'Zag-PythonFeatures'
}

{ #category : 'instance creation' }
ComplexNumber class >> new [
	^self basicNew real: 0 imag: 0
]

{ #category : 'instance creation' }
ComplexNumber class >> real: r imag: i [
	^self basicNew real: r imag: i
]

{ #category : 'comparing' }
ComplexNumber >> = aComplex [
	^self realPart = aComplex realPart and: [ self imaginaryPart = aComplex imaginaryPart ]
]

{ #category : 'comparing' }
ComplexNumber >> hash [
	^(self realPart hashMultiply + self imaginaryPart) hashMultiply
]

{ #category : 'accessing' }
ComplexNumber >> imaginaryPart [
	^imag
]

{ #category : 'private - initialization' }
ComplexNumber >> real: r imag: i [
	real := r.
	imag := i.
]

{ #category : 'accessing' }
ComplexNumber >> realPart [
	"Returns my real part"
	^real
]
