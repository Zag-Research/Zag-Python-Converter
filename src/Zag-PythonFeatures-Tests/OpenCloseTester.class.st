"
I am an object that records whether or not I have been closed, mocking a resource like a file for testing purposes.
"
Class {
	#name : 'OpenCloseTester',
	#superclass : 'Object',
	#instVars : [
		'open'
	],
	#category : 'Zag-PythonFeatures-Tests-Control Flow',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Control Flow'
}

{ #category : 'instance creation' }
OpenCloseTester class >> new [
	| obj |
	obj := self basicNew.
	obj open.
	^obj.
]

{ #category : 'accessing' }
OpenCloseTester >> close [
	open := false.
]

{ #category : 'testing' }
OpenCloseTester >> isOpen [
	^open
]

{ #category : 'accessing' }
OpenCloseTester >> open [
	open := true.
]
