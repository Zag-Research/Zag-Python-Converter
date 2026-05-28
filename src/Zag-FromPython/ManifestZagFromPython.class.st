"
A system that converts Python code into the Zag AST
"
Class {
	#name : 'ManifestZagFromPython',
	#superclass : 'PackageManifest',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagFromPython class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ZagTSNode class' #computeLocals: #true)) #'2026-05-07T15:40:21.053-05:00') )
]

{ #category : 'code-critics' }
ManifestZagFromPython class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ZagTSNode class' #converter: #true)) #'2026-04-08T07:54:23.572-05:00') #(#(#RGMethodDefinition #(#ZagTSNode #binaryToZagASTOperator: #false)) #'2026-04-08T08:28:39.367-05:00') )
]

{ #category : 'code-critics' }
ManifestZagFromPython class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ZagTSNode class' #converter: #true)) #'2026-04-08T08:20:55.15-05:00') #(#(#RGMethodDefinition #(#ZagTSNode #binaryToZagASTOperator: #false)) #'2026-04-08T08:29:04.094-05:00') )
]
