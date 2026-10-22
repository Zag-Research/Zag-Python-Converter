"
I am the Zag converter for array accesses with an interval target.   I convert to slice operations
"
Class {
	#name : 'ZagArrayAccessIntervalTargetConverter',
	#superclass : 'ZagArrayAccessConverter',
	#instVars : [
		'isExclusive',
		'hasStep'
	],
	#category : 'Zag-ToPython-Converter',
	#package : 'Zag-ToPython',
	#tag : 'Converter'
}

{ #category : 'accessing' }
ZagArrayAccessIntervalTargetConverter >> hasStep [

	^ hasStep
]

{ #category : 'accessing' }
ZagArrayAccessIntervalTargetConverter >> hasStep: anObject [

	hasStep := anObject
]

{ #category : 'accessing' }
ZagArrayAccessIntervalTargetConverter >> isExclusive [

	^ isExclusive
]

{ #category : 'accessing' }
ZagArrayAccessIntervalTargetConverter >> isExclusive: anObject [

	isExclusive := anObject
]

{ #category : 'visiting' }
ZagArrayAccessIntervalTargetConverter >> visit: aSend asVisitor: aVisitor [
	self visitStart: aSend target asVisitor: aVisitor.
	aVisitor resultStream nextPut: $:.
	self visitEnd: aSend args first asVisitor: aVisitor.
	self hasStep ifTrue: [ 
		aVisitor resultStream nextPut: $:.
		aVisitor visit: aSend args second.
	].
]

{ #category : 'visiting' }
ZagArrayAccessIntervalTargetConverter >> visitEnd: aZagAST asVisitor: aVisitor [
	| offset |
	aZagAST = (ASLiteral literal: nil) ifTrue: [ "don't print anything" ^self ].
	offset := 0.
	self isExclusive ifFalse: [ offset := offset + 1 ].
	self isZeroIndexed ifFalse: [ offset := offset - 1 ].
	offset = 0 ifFalse: [ aVisitor resultStream nextPut: $( ].
	aVisitor visit: aZagAST.
	offset = 0 ifFalse: [
		aVisitor resultStream
			nextPutAll: (offset positive ifTrue: [ ') + ' ] ifFalse: [ ') - ' ]);
			nextPutAll: offset abs asString
	].
]

{ #category : 'visiting' }
ZagArrayAccessIntervalTargetConverter >> visitStart: aZagAST asVisitor: aVisitor [
	aVisitor visit: aZagAST.
	self isZeroIndexed ifFalse: [ aVisitor resultStream nextPutAll: ' - 1' ].
]
