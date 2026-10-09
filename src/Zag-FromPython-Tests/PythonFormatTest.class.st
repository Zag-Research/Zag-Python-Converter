"
I test the ZagTSNode class's formatCode: message, ensuring that it properly formats code for tree-sitter.
"
Class {
	#name : 'PythonFormatTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests-Tests',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Tests'
}

{ #category : 'asserting' }
PythonFormatTest >> assert: pythonCode formatsTo: expected [
	| actual |
	actual := ZagTSNode formatCode: pythonCode.
	self assert: expected equals: actual.
]

{ #category : 'tests' }
PythonFormatTest >> testBackslashSemicolon [
	"Ensure line escapes are formatted properly."
	self
		assert: 'a + b\
+ c'
		formatsTo: 'a + b\
+ c;
'
]

{ #category : 'tests' }
PythonFormatTest >> testBasicSemicolon [
	"Ensures semicolons are normally placed after each line."
	self
		assert: 'a = 2
b = a + 2
print(a, b)'
		formatsTo: 'a = 2;
b = a + 2;
print(a, b);
'
]

{ #category : 'tests' }
PythonFormatTest >> testBracketSemicolon [
	"Ensure bracket-based multiline statements are formatted properly."
	self
		assert: '(a + b + (x * y)
+ c)'
		formatsTo: '(a + b + (x * y)
+ c);
';
		assert: '[a, b, [x, y]
, c]'
		formatsTo: '[a, b, [x, y]
, c];
';
		assert: '{a, b, {x, y}
, c}'
		formatsTo: '{a, b, {x, y}
, c};
';
		assert: '{a, b, [x, y]
, c}'
		formatsTo: '{a, b, [x, y]
, c};
'
]

{ #category : 'tests' }
PythonFormatTest >> testIfSemicolon [
	"Ensure if statements are formatted properly."
	self
		assert: 'if a:
	print("a")
elif b:
	print("b")
else:
	print("c")'
		formatsTo: 'if a:
	print("a");
elif b:
	print("b");
else:
	print("c");
'
]

{ #category : 'tests' }
PythonFormatTest >> testMultilineStringSemicolon [
	"Ensure semicolons aren't inserted into multiline string literals."
	self
		assert: 'a = """line 1
line 2
line 3"""'
		formatsTo: 'a = """line 1
line 2
line 3""";
';
		assert: 'a = ''''''line 1
line 2
line 3'''''''
		formatsTo: 'a = ''''''line 1
line 2
line 3'''''';
'
]

{ #category : 'tests' }
PythonFormatTest >> testMultilineStringWithQuoteSemicolon [
	"Ensure semicolons aren't inserted into multiline string literals with quote characters."
	self
		assert: 'a = """line 1"
line 2''
line 3"""'
		formatsTo: 'a = """line 1"
line 2''
line 3""";
';
		assert: 'a = ''''''line 1"
line 2''
line 3'''''''
		formatsTo: 'a = ''''''line 1"
line 2''
line 3'''''';
'
]
