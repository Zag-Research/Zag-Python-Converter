Extension { #name : 'OrderedCollection' }

{ #category : '*Zag-PythonFeatures' }
OrderedCollection >> zwRemoveAt: index [
	"Like removeAt:, but uses zero-indexing and negative indices wrap around to the end."
	"e.g. zwRemoveAt: -1 removes the last element."
	index isInterval ifTrue: [ ^self zwRemoveFrom: index first to: index stop by: index increment ].
	^self removeAt: (index >= 0 ifTrue: [ index + 1 ] ifFalse: [ index + 1 + self size ]).
]

{ #category : '*Zag-PythonFeatures' }
OrderedCollection >> zwRemoveFrom: zwStart to: zwEnd [
	^self zwRemoveFrom: zwStart to: zwEnd by: 1
]

{ #category : '*Zag-PythonFeatures' }
OrderedCollection >> zwRemoveFrom: zwStart to: zwEnd by: by [
	| zStart zEnd i |
	zStart := zwStart \\ self size.
	zEnd := zwEnd = #end
		ifTrue: [ self size ]
		ifFalse: [ zwEnd < 0
			ifTrue: [ zwEnd + self size ]
			ifFalse: [ zwEnd ] ].
	i := zStart.
	[ i < zEnd ] whileTrue: [
		self zwRemoveAt: i.
		i := i + by - 1.
		zEnd := zEnd - 1.
	].
]
