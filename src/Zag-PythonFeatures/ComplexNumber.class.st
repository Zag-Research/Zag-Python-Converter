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

{ #category : 'arithmetic' }
ComplexNumber >> * arg [
	| myReal myImag theirReal theirImag |
	myReal := self realPart.
	myImag := self imaginaryPart.
	theirReal := arg isComplexNumber ifTrue: [ arg realPart ] ifFalse: [ arg ].
	theirImag := arg isComplexNumber ifTrue: [ arg imaginaryPart ] ifFalse: [ 0 ].
	^self class
		real: (myReal * theirReal) - (myImag * theirImag)
		imag: (myReal * theirImag) + (myImag * theirReal)
]

{ #category : 'arithmetic' }
ComplexNumber >> + arg [
	^arg isComplexNumber
		ifTrue: [ self class real: self realPart + arg realPart imag: self imaginaryPart + arg imaginaryPart ]
		ifFalse: [ self class real: self realPart + arg imag: self imaginaryPart ]
]

{ #category : 'arithmetic' }
ComplexNumber >> - arg [
	^arg isComplexNumber
		ifTrue: [ self class real: self realPart - arg realPart imag: self imaginaryPart - arg imaginaryPart ]
		ifFalse: [ self class real: self realPart - arg imag: self imaginaryPart ]
]

{ #category : 'arithmetic' }
ComplexNumber >> / arg [
	| myReal myImag theirReal theirImag theirSquareNorm |
	myReal := self realPart.
	myImag := self imaginaryPart.
	theirReal := arg isComplexNumber ifTrue: [ arg realPart ] ifFalse: [ arg ].
	theirImag := arg isComplexNumber ifTrue: [ arg imaginaryPart ] ifFalse: [ 0 ].
	theirSquareNorm := theirReal squared + theirImag squared.
	^self class
		real: (myReal * theirReal) + (myImag * theirImag) / theirSquareNorm
		imag: (myImag * theirReal) - (myReal * theirImag) / theirSquareNorm
]

{ #category : 'comparing' }
ComplexNumber >> = aComplex [
	^aComplex isComplexNumber and: [ self realPart = aComplex realPart and: [ self imaginaryPart = aComplex imaginaryPart ] ]
]

{ #category : 'converting' }
ComplexNumber >> adaptToNumber: rcvr andSend: selector [
	"If I am involved in arithmetic with a number, convert it to a complex number."
	| asComplex |
	asComplex := self class real: rcvr imag: 0.
	^asComplex perform: selector with: self.
]

{ #category : 'arithmetic' }
ComplexNumber >> conjugate [
	^self class real: self realPart imag: self imaginaryPart negated
]

{ #category : 'comparing' }
ComplexNumber >> hash [
	^(self realPart hashMultiply + self imaginaryPart) hashMultiply
]

{ #category : 'accessing' }
ComplexNumber >> imaginaryPart [
	^imag
]

{ #category : 'testing' }
ComplexNumber >> isComplexNumber [
	^true
]

{ #category : 'arithmetic' }
ComplexNumber >> negated [
	^self class real: self realPart negated imag: self imaginaryPart negated
]

{ #category : 'printing' }
ComplexNumber >> printOn: aStream [
	self printOn: aStream base: 10
]

{ #category : 'printing' }
ComplexNumber >> printOn: aStream base: base [
	aStream nextPut: $(.
	self realPart printOn: aStream base: base.
	aStream nextPutAll: ' + '.
	self imaginaryPart printOn: aStream base: base.
	aStream nextPutAll: 'i)'.
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
