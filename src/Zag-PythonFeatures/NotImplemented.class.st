"
I am a placeholder class that represents the Python object NotImplemented.  In particular, I am not an exception.
"
Class {
	#name : 'NotImplemented',
	#superclass : 'Object',
	#category : 'Zag-PythonFeatures-Basic Types',
	#package : 'Zag-PythonFeatures',
	#tag : 'Basic Types'
}

{ #category : 'instance creation' }
NotImplemented class >> new [
	self error: 'Use the NotImplemented class as an object.'
]
