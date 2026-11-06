Class {
	#name : 'ZagExceptionTest',
	#superclass : 'TestCase',
	#category : 'Zag-PythonFeatures-Tests-Exceptions',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Exceptions'
}

{ #category : 'tests' }
ZagExceptionTest >> testOnDoElseError [
	"Ensure else: does not block errors."
	self should: [ [ nil ] on: Error do: [ nil ] else: [ Error signal ] ] raise: Error
]

{ #category : 'tests' }
ZagExceptionTest >> testOnDoElseReturn [
	"Ensure else: does not block errors."
	self assert: ([ Error signal ] on: Error do: [ true ] else: [ false ])
]

{ #category : 'tests' }
ZagExceptionTest >> testOnErrorDoElseError [
	"Ensure else: does not block errors."
	self should: [ [ nil ] onErrorDo: [ nil ] else: [ Error signal ] ] raise: Error
]

{ #category : 'tests' }
ZagExceptionTest >> testOnErrorDoElseReturn [
	"Ensure else: does not block errors."
	self assert: ([ Error signal ] onErrorDo: [ true ] else: [ false ])
]
