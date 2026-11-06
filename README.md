# Zag To/From Python

This is a project that converts Python code to and from [Zag Smalltalk](https://github.com/Zag-Research/Zag-Smalltalk)'s AST.  It is implemented in [Pharo Smalltalk](https://pharo.org/).

This project is currently in the early stages of development; don't expect every Python feature to work at the moment.

## Progress

[See the development roadmap here.](./docs/roadmap.md)

More precise information about this system can be obtained using Smalltalk:
```smalltalk
"The set of tree-sitter node types that can be converted from"
ZagTSConverter converterRules keys.

"The set of Python builtin functions that can be converted from"
ZagTSBuiltinConverter builtinConverterRules keys.

"The set of Smalltalk send selectors that can be converted from, including custom ones"
ZagSendConverter converterRules keys.
```

## Installation

```smalltalk
Metacello new
	githubUser: 'Zag-Research' project: 'Zag-Python-Converter' commitish: 'main' path: 'src';
	baseline: 'ZagPythonConverter';
	load
```

## Use Instructions

To convert Python code to a Zag AST:
```smalltalk
ZagTSNode pythonToZagAST: '[PYTHON CODE]'
```

To convert a Zag AST to Python:
```smalltalk
myZagAST asPythonSource
```

## Dependencies

- [Tree Sitter](https://tree-sitter.github.io/tree-sitter/), Pharo Smalltalk version, for Python→Zag parsing
- [Zag Smalltalk](https://github.com/Zag-Research/Zag-Smalltalk)

## Extension Messages

This project implements a few extension messages in order to handle things as they would be in Python.  Translated code uses these extensions in certain situations.
- `toPythonBoolean` converts a value to a boolean based on Python truthiness.  Related messages like `pythonOr:` do boolean operations based on truthiness.
- `zwAt:` and related messages allows indexing arrays according to Python conventions (initial index is 0, negative indices access elements at the end).
- `switch` implements a switch/cond statement, used for translating if/elif statements.  `ifTrue:` and `ifTrue:ifFalse:` are used for if statements without elifs.
- Complex numbers are implemented, with all the features they have in Python.

All of these feature extensions can be found in the `Zag-PythonFeatures` package.

## Authors/Contact

This is the thesis project of [Adrien Hopkins](https://ahopkins.ca/) (<a1hopkins@torontomu.ca>), made as part of the [Zag Research](https://github.com/Zag-Research/) team and the [Human-Centered Systems Lab](https://hcsl-tmu.ca/).
