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
	#category : 'Zag-PythonFeatures-Math',
	#package : 'Zag-PythonFeatures',
	#tag : 'Math'
}

{ #category : 'instance creation' }
ComplexNumber class >> magnitude: mag argument: arg [
	"Returns a complex number from its polar coordinate (argument is in radians)."
	^mag * arg i exp
]

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
ComplexNumber >> ** exponent [
	^self raisedTo: exponent
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

{ #category : 'mathematical functions' }
ComplexNumber >> abs [
	^(self realPart squared + self imaginaryPart squared) sqrt
]

{ #category : 'converting' }
ComplexNumber >> adaptToNumber: rcvr andSend: selector [
	"If I am involved in arithmetic with a number, convert it to a complex number."
	| asComplex |
	asComplex := self class real: rcvr imag: 0.
	^asComplex perform: selector with: self.
]

{ #category : 'mathematical functions' }
ComplexNumber >> argument [
	"Returns the angle between the number 1 and me, in radians."
	^self imaginaryPart arcTan: self realPart
]

{ #category : 'comparing' }
ComplexNumber >> closeTo: aNumber [
	^self closeTo: aNumber precision: Float defaultComparisonPrecision
]

{ #category : 'comparing' }
ComplexNumber >> closeTo: aNumber precision: epsilon [
	(aNumber isNumber or: [ aNumber isComplexNumber ]) ifFalse: [ ^false ].
	^self = (aNumber + 0i) or: [ (self - aNumber) abs <= epsilon ].
]

{ #category : 'arithmetic' }
ComplexNumber >> conjugate [
	^self class real: self realPart imag: self imaginaryPart negated
]

{ #category : 'mathematical functions' }
ComplexNumber >> exp [
	"Answer the exponential of the receiver as a complex number."
	^self class
		real: self realPart exp * self imaginaryPart cos
		imag: self realPart exp * self imaginaryPart sin
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

{ #category : 'mathematical functions' }
ComplexNumber >> ln [
	"Returns my principal natural logarithm"
	^self abs ln + (self imaginaryPart arcTan: self realPart) i
]

{ #category : 'mathematical functions' }
ComplexNumber >> log: base [
	"Answers my logarithm base the provided number"
	^self ln / base ln
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

{ #category : 'arithmetic' }
ComplexNumber >> raisedTo: exponent [
	^(exponent * self ln) exp
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

{ #category : 'arithmetic' }
ComplexNumber >> reciprocal [
	^1 / self
]

{ #category : 'arithmetic' }
ComplexNumber >> sqrt [
	^self raisedTo: 0.5
]
