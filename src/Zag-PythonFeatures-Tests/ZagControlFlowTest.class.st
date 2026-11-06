Class {
	#name : 'ZagControlFlowTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Control Flow',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Control Flow'
}

{ #category : 'tests' }
ZagControlFlowTest >> testEnsureClosesError [
	"Test ensureClosesAfter: works if the block raises an error."
	| tester |
	tester := OpenCloseTester new.
	[ [ tester ] ensureClosesAfter: [ :c | Error signal ] ] onErrorDo: [ nil ].
	self assert: tester isOpen not.
]

{ #category : 'tests' }
ZagControlFlowTest >> testEnsureClosesNoError [
	"Test ensureClosesAfter: works if the block doesn't raise an error."
	| tester |
	tester := OpenCloseTester new.
	[ tester ] ensureClosesAfter: [ :c | nil ].
	self assert: tester isOpen not.
]

{ #category : 'tests' }
ZagControlFlowTest >> testOnDoElseError [
	"Ensure else: does not block errors."
	self should: [ [ nil ] on: Error do: [ nil ] else: [ Error signal ] ] raise: Error
]

{ #category : 'tests' }
ZagControlFlowTest >> testOnDoElseReturn [
	"Ensure else: does not block errors."
	self assert: ([ Error signal ] on: Error do: [ true ] else: [ false ])
]

{ #category : 'tests' }
ZagControlFlowTest >> testOnErrorDoElseError [
	"Ensure else: does not block errors."
	self should: [ [ nil ] onErrorDo: [ nil ] else: [ Error signal ] ] raise: Error
]

{ #category : 'tests' }
ZagControlFlowTest >> testOnErrorDoElseReturn [
	"Ensure else: does not block errors."
	self assert: ([ Error signal ] onErrorDo: [ true ] else: [ false ])
]
