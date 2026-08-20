"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagPythonFeatures',
	#superclass : 'PackageManifest',
	#category : 'Zag-PythonFeatures-Manifest',
	#package : 'Zag-PythonFeatures',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagPythonFeatures class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ComplexNumber #adaptToNumber:andSend: #false)) #'2026-08-20T10:42:26.286-05:00') )
]
