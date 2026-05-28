"
Tests for the Zag-FromPython package.
"
Class {
	#name : 'ManifestZagFromPythonTests',
	#superclass : 'PackageManifest',
	#category : 'Zag-FromPython-Tests-Manifest',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagFromPythonTests class >> ruleReAssertWithBooleanEqualtiyRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#PythonTruthyTest)) #'2026-03-19T11:26:44.11-05:00') )
]
