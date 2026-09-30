Extension { #name : 'Collection' }

{ #category : '*Zag-PythonFeatures' }
Collection >> switch [
	"Returns the value of the first element with a true key.  Returns nil if no key is true."
	"Functions like a switch/case statement in other languages."
	"Both key and value can be blocks, but neither has to be."
	"This statement is used by Zag-FromPython to translate if statements with elif cases.  In most other cases, it is generally more Smalltalky to use a different paradigm, such as switch methods like ZagTSNode>>#converter:, or multiple classes with the switch code as a method they all implement.  These alternatives are likely to perform better than this method."
	
	"|a| a := 2. { a > 2 -> 'greater' . a < 2 -> 'less' . true -> 'equal' } switch >>> 'equal'"
	"|a| a := 2. { a > 2 -> 'greater' . a <= 2 -> 'less/equal' . true -> 'equal' } switch >>> 'less/equal'"
	"|a| a := 2. { a >= 2 -> 'greater/equal' . a <= 2 -> 'less/equal' . true -> 'equal' } switch >>> 'greater/equal'"
	
	^self detect: [ :each | each key value ] ifFound: [ :each | each value value ] ifNone: nil.
]

{ #category : '*Zag-PythonFeatures' }
Collection >> toPythonBoolean [
	^self isNotEmpty.
]
