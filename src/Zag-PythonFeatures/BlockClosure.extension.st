Extension { #name : 'BlockClosure' }

{ #category : '*Zag-PythonFeatures' }
BlockClosure >> on: exception do: handlerAction else: otherAction [
	"Like on:do: but execute otherAction if no error happened."
	| hadException returnValue |
	hadException := false.
	returnValue := self on: exception do: [ :ex | hadException := true. handlerAction cull: ex ].
	hadException ifFalse: [ returnValue := otherAction value ].
	^returnValue
]

{ #category : '*Zag-PythonFeatures' }
BlockClosure >> onErrorDo: errorHandlerBlock else: otherBlock [
	"Like onErrorDo: but execute otherBlock if there was no errer."
	^ self on: Error do: [:ex | errorHandlerBlock cull: ex] else: otherBlock
]
