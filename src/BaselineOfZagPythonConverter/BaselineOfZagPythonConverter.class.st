"
I am the baseline for the Zag-Python Converter project.

Repository: https://github.com/Zag-Research/Zag-Python-Converter
"
Class {
	#name : 'BaselineOfZagPythonConverter',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfZagPythonConverter',
	#package : 'BaselineOfZagPythonConverter'
}

{ #category : 'baselines' }
BaselineOfZagPythonConverter >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			spec 
    			baseline: 'ZagSmalltalk' 
    			with: [ spec repository: 'github://Zag-Research/Zag-Smalltalk:remove-benchmarks/src' ].
			spec 
    			baseline: 'TreeSitter' 
    			with: [ spec repository: 'github://Evref-BL/Pharo-Tree-Sitter:1a3095b/src' ].
			
			"Packages"
			spec
				package: 'Zag-Python';
				package: 'Zag-FromPython' with: [ spec requires: #('ZagSmalltalk' 'TreeSitter') ];
				package: 'Zag-FromPython-Tests' with: [ spec requires: #('Zag-FromPython') ]
		]
]

{ #category : 'accessing' }
BaselineOfZagPythonConverter >> projectClass [
	^ MetacelloCypressBaselineProject
]
