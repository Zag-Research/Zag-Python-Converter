# Zag To/From Python

This is a project that converts Python code to and from [Zag Smalltalk](https://github.com/Zag-Research/Zag-Smalltalk)'s AST.  It is implemented in [Pharo Smalltalk](https://pharo.org/).

This project is currently in the early stages of development; don't expect every Python feature to work at the moment.

## Installation

```
Metacello new
	githubUser: 'Zag-Research' project: 'Zag-Python-Converter' commitish: 'main' path: 'src';
	baseline: 'ZagPythonConverter';
	load
```

## Use Instructions

To convert Python code to a Zag AST:
```
ZagTSNode pythonToZagAST: '[PYTHON CODE]'
```

## Dependencies

- [Tree Sitter](https://tree-sitter.github.io/tree-sitter/), Pharo Smalltalk version

## Extension Messages

This project implements a few extension messages in order to handle things as they would be in Python.  Translated code uses these extensions in certain situations.
- `toPythonBoolean` converts a value to a boolean based on Python truthiness.  Related messages like `pythonOr:` do boolean operations based on truthiness.
- `zwAt:` and related messages allows indexing arrays according to Python conventions (initial index is 0, negative indices access elements at the end).
- `switch` implements a switch/cond statement, used for translating if/elif statements.  `ifTrue:` and `ifTrue:ifFalse:` are used for if statements without elifs.

## Authors/Contact

This is the thesis project of [Adrien Hopkins](https://ahopkins.ca/) (<a1hopkins@torontomu.ca>), made as part of the [Zag Research](https://github.com/Zag-Research/) team.
