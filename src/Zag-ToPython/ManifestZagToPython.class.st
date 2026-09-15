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
	^ #(#(#(#RGMetaclassDefinition #(#'ZagToPythonVisitor class' #ZagToPythonVisitor)) #'2026-06-19T15:11:37.535-05:00') #(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitStatements: #false)) #'2026-06-26T08:34:36.534-05:00') #(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitSend: #false)) #'2026-09-14T12:56:06.885-05:00') )
]

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleEqualsTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ZagToPythonVisitor #outputFormattedIfElseStatement: #false)) #'2026-06-25T17:39:20.865-05:00') #(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitLiteral: #false)) #'2026-09-11T11:40:00.554-05:00') #(#(#RGMethodDefinition #(#ZagToPythonVisitor #outputFormattedIfElse: #false)) #'2026-09-11T19:13:14.526-05:00') #(#(#RGMethodDefinition #(#ZagIfElseConverter #acceptStatement:asVisitor: #false)) #'2026-09-15T11:02:43.599-05:00') #(#(#RGMethodDefinition #(#'ZagIfElseConverter class' #representsElse: #true)) #'2026-09-15T11:12:37.253-05:00') )
]

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitSend: #false)) #'2026-06-26T10:22:02.716-05:00') )
]

{ #category : 'code-critics' }
ManifestZagToPython class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ZagToPythonVisitor #visitSend: #false)) #'2026-06-26T10:45:51.904-05:00') )
]
