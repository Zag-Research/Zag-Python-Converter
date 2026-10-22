Extension { #name : 'SequenceableCollection' }

{ #category : '*Zag-PythonFeatures' }
SequenceableCollection >> zwAt: index [
	"Like at:, but uses zero-indexing and negative indices wrap around to the end."
	"e.g. zwAt: -1 gets the last element."
	index isInterval ifTrue: [ "intervals are special as to can be negative or nil"
		^self zwCopyFrom: index first to: (index stop ifNotNil: [ :i | i + 1 ]) by: index increment ].
	index isCollection ifTrue: [ ^index collect: [ :i | self zwAt: i ] ].
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
	"You may also make the second argument #end to copy to the end."
	| stFrom stTo |
	stFrom := zwFrom >= 0 ifTrue: [ zwFrom + 1 ] ifFalse: [ zwFrom + 1 + self size ].
	stTo := zwTo ifNil: [ self size ].
	stTo < 0 ifTrue: [ stTo := stTo + self size ].
	^stFrom >= stTo
		ifTrue: [ self species new: 0 ]
		ifFalse: [ self copyFrom: stFrom to: stTo ].
]

{ #category : '*Zag-PythonFeatures' }
SequenceableCollection >> zwCopyFrom: zwFrom to: zwTo by: by [
	"Copy my elements from zwFrom to zwTo with the step by."
	| stFrom stTo newSize copy j |
	stFrom := zwFrom >= 0 ifTrue: [ zwFrom + 1 ] ifFalse: [ zwFrom + 1 + self size ].
	stTo := (zwTo ifNil: [ self size ]).
	stTo < 0 ifTrue: [ stTo := stTo + self size ].
	newSize := ((stTo - stFrom + 1) / by) ceiling.
	copy := self species new: newSize.
	j := 1.
	stFrom to: stTo by: by do: [ :i |
		copy at: j put: (self at: i).
		j := j + 1.
	].
	^copy.
	
]
