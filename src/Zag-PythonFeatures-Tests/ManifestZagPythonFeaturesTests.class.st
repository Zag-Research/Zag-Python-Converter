"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagPythonFeaturesTests',
	#superclass : 'PackageManifest',
	#category : 'Zag-PythonFeatures-Tests-Manifest',
	#package : 'Zag-PythonFeatures-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagPythonFeaturesTests class >> ruleReAssertWithBooleanEqualtiyRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#PythonTruthyTest)) #'2026-09-18T09:42:57.935-05:00') )
]

{ #category : 'code-critics' }
ManifestZagPythonFeaturesTests class >> ruleUnaryAccessingMethodWithoutReturnRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#OpenCloseTester)) #'2026-11-06T14:05:08.05-05:00') )
]
