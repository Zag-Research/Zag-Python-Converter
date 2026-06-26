Extension { #name : 'ASCodeBlock' }

{ #category : '*Zag-ToPython' }
ASCodeBlock >> negateLastStatement [
	"Returns a block with a 'not' appended to my last statement, negating my output."
	| negatedLast negatedBody |
	self body isEmptyOrNil ifTrue: [ self error: 'Cannot call negateLastStatement on empty/nil blocks.' ].
	negatedLast := ASSend target: self body last selector: #not args: #().
	negatedBody := self body allButLast copyWith: negatedLast.
	^self clone body: negatedBody; yourself.
]
