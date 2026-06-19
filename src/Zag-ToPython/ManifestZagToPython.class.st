"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagToPython',
	#superclass : 'PackageManifest',
	#category : 'Zag-ToPython-Manifest',
	#package : 'Zag-ToPython',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMetaclassDefinition #(#'ZagToPythonVisitor class' #ZagToPythonVisitor)) #'2026-06-19T15:11:37.535-05:00') )
]
