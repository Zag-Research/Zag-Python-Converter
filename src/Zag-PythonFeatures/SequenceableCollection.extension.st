Extension { #name : 'SequenceableCollection' }

{ #category : '*Zag-PythonFeatures' }
SequenceableCollection >> zwAt: index [
	"Like at:, but uses zero-indexing and negative indices wrap around to the end."
	"e.g. zwAt: -1 gets the last element."
	^self at: (index >= 0 ifTrue: [ index + 1 ] ifFalse: [ index + 1 + self size ]).
]

{ #category : '*Zag-PythonFeatures' }
SequenceableCollection >> zwAt: index put: anObject [
	"Like at:put:, but uses the same index semantics as swAt:"
	^self at: (index >= 0 ifTrue: [ index + 1 ] ifFalse: [ index + 1 + self size ]) put: anObject.
]

{ #category : '*Zag-PythonFeatures' }
SequenceableCollection >> zwCopyFrom: zwFrom to: zwTo [
	"Like copyFrom:to:, but with the same index semantics as zwAt:"
	| stFrom stTo |
	stFrom := zwFrom >= 0 ifTrue: [ zwFrom + 1 ] ifFalse: [ zwFrom + 1 + self size ].
	stTo := zwTo >= 0 ifTrue: [ zwTo ] ifFalse: [ zwTo + self size ].
	^stFrom >= stTo
		ifTrue: [ self species new: 0 ]
		ifFalse: [ self copyFrom: stFrom to: stTo ].
]
