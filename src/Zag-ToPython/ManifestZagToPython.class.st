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
	^ #(#(#(#RGMetaclassDefinition #(#'ZagToPythonVisitor class' #ZagToPythonVisitor)) #'2026-06-19T15:11:37.535-05:00') #(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitStatements: #false)) #'2026-06-26T08:34:36.534-05:00') )
]

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleEqualsTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ZagToPythonVisitor #outputFormattedIfElse: #false)) #'2026-06-25T17:39:20.865-05:00') )
]

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitSend: #false)) #'2026-06-26T10:22:02.716-05:00') )
]
