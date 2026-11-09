Class {
	#name : 'BreakContinueTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Control Flow',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Control Flow'
}

{ #category : 'tests' }
BreakContinueTest >> testBreakContinueDo [
	| a |
	a := OrderedCollection new.
	(1 to: 20) doWithBreak: [ :i :bc |
		i = 15 ifTrue: [ bc break ].
		i isPrime ifTrue: [ bc continue ].
		a add: i.
	].
	self assert: a equals: #(1 4 6 8 9 10 12 14) asOrderedCollection
]

{ #category : 'tests' }
BreakContinueTest >> testBreakContinueWhile [
	| a i |
	a := OrderedCollection new.
	i := 0.
	[ a size < 12 ] whileTrueWithBreak: [ :bc |	
		i := i + 1.
		i > 4 & i isPowerOfTwo ifTrue: [ bc break ].
		i isPrime ifTrue: [ bc continue ].
		a add: i.
	].
	self assert: a equals: #(1 4 6) asOrderedCollection
]

{ #category : 'tests' }
BreakContinueTest >> testBreakDo [
	| a |
	a := OrderedCollection new.
	(1 to: 20) doWithBreak: [ :i :bc |
		i = 15 ifTrue: [ bc break ].
		a add: i.
	].
	self assert: a equals: (1 to: 14) asOrderedCollection
]

{ #category : 'tests' }
BreakContinueTest >> testBreakWhile [
	| a i |
	a := OrderedCollection new.
	i := 0.
	[ a size < 12 ] whileTrueWithBreak: [ :bc |
		i := i + 1.
		i > 4 & i isPowerOfTwo ifTrue: [ bc break ].
		a add: i.
	].
	self assert: a equals: (1 to: 7) asOrderedCollection
]

{ #category : 'tests' }
BreakContinueTest >> testContinueDo [
	| a |
	a := OrderedCollection new.
	(1 to: 20) doWithBreak: [ :i :bc |
		i isPrime ifTrue: [ bc continue ].
		a add: i.
	].
	self assert: a equals: #(1 4 6 8 9 10 12 14 15 16 18 20) asOrderedCollection
]

{ #category : 'tests' }
BreakContinueTest >> testContinueWhile [
	| a i |
	a := OrderedCollection new.
	i := 0.
	[ a size < 12 ] whileTrueWithBreak: [ :bc |	
		i := i + 1.
		i isPrime ifTrue: [ bc continue ].
		a add: i.
	].
	self assert: a equals: #(1 4 6 8 9 10 12 14 15 16 18 20) asOrderedCollection
]
