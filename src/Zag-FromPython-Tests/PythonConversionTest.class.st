Class {
	#name : 'PythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests-Tests',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Tests'
}

{ #category : 'tests - helpers' }
PythonConversionTest >> assertExpression: source convertsTo: tree [
	"Asserts the provided Python code converts to the provided AST."
	"Puts the provided AST in a main method."
	| expected actual |
	expected := ASMethodNode selector: ZagTSNode mainMethodSelector body: {tree}.
	actual := ZagTSNode pythonToZagAST: source.
	self assert: actual equals: expected.
]

{ #category : 'tests - helpers' }
PythonConversionTest >> assertExpression: source convertsTo: tree withLocals: locals [
	"Asserts the provided Python code converts to the provided AST."
	"Puts the provided AST in a main method."
	| expected actual |
	expected := ASMethodNode selector: ZagTSNode mainMethodSelector locals: (locals collect: [:each | ASRef variable: each]) body: {tree}.
	actual := ZagTSNode pythonToZagAST: source.
	self assert: actual equals: expected.
]

{ #category : 'tests - helpers' }
PythonConversionTest >> assertExpression: source convertsToAnyOf: trees [
	"Asserts the provided Python code converts to any of the provided possibilities."
	"Puts the provided AST in a main method."
	| expecteds actual |
	expecteds := trees collect: [ :tree | ASMethodNode selector: ZagTSNode mainMethodSelector body: {tree} ].
	actual := ZagTSNode pythonToZagAST: source.
	self assert: (expecteds includes: actual).
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAddition [
	"Ensure an addition expression can be converted to Zag properly."
	| expected source |
	source := 'a + b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAndOrOperator [
	"Ensure an 'and' expression can be converted to Zag properly."
	| expected source |
	source := 'a and b or c'. "= (a and b) or c"
	expected := ASSend
		target: (ASSend
			target: (ASRef variable: #a)
			selector: #pythonAnd:
			args: {ASBlockNode
				arguments: #() locals: #() body: { ASRef variable: #b }})
		selector: #pythonOr:
		args: {ASBlockNode
			arguments: #() locals: #() body: { ASRef variable: #c }}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testArrayAccess [
	"Ensures an array access (i.e. array[index]) translates properly."
	| expected |
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #zwAt:
		args: { ASRef variable: #b }.
	self assertExpression: 'a[b]' convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testArrayAssign [
	"Ensure an assignment expression can be converted to Zag properly."
	| expected source |
	source := 'a[b] = c'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #zwAt:put:
		args: { ASRef variable: #b . ASRef variable: #c }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testArrayAssignPlus [
	"Ensure an augmented assignment expression (+=) can be converted to Zag properly."
	| expected source |
	source := 'a[b] += c'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #zwAt:put:
		args: { ASRef variable: #b . ASSend
			target: (ASSend
				target: (ASRef variable: #a)
				selector: #zwAt:
				args: { ASRef variable: #b }
			)
			selector: #+
			args: { ASRef variable: #c }
		}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testArrayLiteralNode [
	"Tests converting array/list literals"
	self assertExpression: '[a, b, c]' convertsTo: (ASArray statements: {
		ASRef variable: #a . ASRef variable: #b . ASRef variable: #c })
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testAssert [
	"Tests that basic assert statements can be translated properly."
	self
		assertExpression: 'assert a == b'
		convertsTo: (ASSend target: (
			ASBlockNode locals: #() body: {
				ASSend target: (ASRef variable: #a) selector: #= args: { ASRef variable: #b } })
			selector: #assert)
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testAssertDescription [
	"Tests that assert statements with a description can be translated properly."
	self
		assertExpression: 'assert a == b, "test error message"'
		convertsTo: (ASSend target: (
			ASBlockNode locals: #() body: {
				ASSend target: (ASRef variable: #a) selector: #= args: { ASRef variable: #b } })
			selector: #assertWithDescription: args: { ASLiteral literal: 'test error message' })
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testAssign [
	"Ensure an assignment expression can be converted to Zag properly."
	| expected source |
	source := 'a = b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASRef variable: #b).
	self assertExpression: source convertsTo: expected withLocals: #(#a).
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testAssignPlus [
	"Ensure an augmented assignment expression (+=) can be converted to Zag properly."
	| expected source |
	source := 'a += b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASSend
			target: (ASRef variable: #a)
			selector: #+
			args: { ASRef variable: #b }).
	self assertExpression: source convertsTo: expected withLocals: #(#a).
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testBasicIf [
	"Tests converting an if statement without any elif or else blocks."
	| source expected |
	source := 'if condition:
	x = 0'.
	expected := ASSend
		target: (ASSend target: (ASRef variable: #condition) selector: #asPythonBoolean)
		selector: #ifTrue: args: {
		ASBlockNode arguments: #() locals: #() body: {
			ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 0)}}.
	self assertExpression: source convertsTo: expected "withLocals: #(#x)".
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftLeft [
	"Ensure a left bit shift expression can be converted to Zag properly."
	| expected source |
	source := 'a << b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftRight [
	"Ensure a right bit shift expression can be converted to Zag properly.  Included because it has unique semantics compared to left shift."
	| expected source |
	source := 'a >> b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #negated
			args: #()}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testBooleanNodes [
	"Test that the true and false literals convert properly."
	self assertExpression: 'True' convertsTo: (ASLiteral literal: true).
	self assertExpression: 'False' convertsTo: (ASLiteral literal: false).
]

{ #category : 'tests - functions' }
PythonConversionTest >> testBytearrayCall [
	"Ensures bytearray() converts properly."
	self assertExpression: 'bytearray(10)' convertsTo: (
		ASSend target: (ASRef variable: #ByteArray) selector: #fromNumberOrString: args: {
			ASLiteral literal: 10 }).
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testComparison [
	"Ensure a comparison expression can be converted to Zag properly."
	| expected source |
	source := 'a > b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #>
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testComplexNumberNode [
	"Tests that complex literals convert properly."
	self assertExpression: '10j' convertsTo: (ASSend target: (ASLiteral literal: 10) selector: #i).
	
	self assertExpression: '1j' convertsTo: (ASSend target: (ASLiteral literal: 1) selector: #i).
	self assertExpression: '0j' convertsTo: (ASSend target: (ASLiteral literal: 0) selector: #i).
	self assertExpression: '0.5j' convertsTo: (ASSend target: (ASLiteral literal: 0.5) selector: #i).
]

{ #category : 'tests - literals' }
PythonConversionTest >> testEllipsisNode [
	self assertExpression: 'Ellipsis' convertsTo: (ASLiteral literal: Ellipsis).
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testEquals [
	"Ensure an == expression can be converted to Zag properly."
	| expected source |
	source := 'a == b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #=
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - full programs' }
PythonConversionTest >> testFToC [
	"Test converting a fahrenheit-to-celsius converter"
	| source expected actual |
	source := 'tempF = float(input("Input temp in F: "))
tempC = (tempF - 32) / 1.8
print(tempC)'.
	expected := ASMethodNode selector: #main
			locals: {(ASRef variable: #tempF) . (ASRef variable: #tempC)} body: {
		ASAssign variable: (ASRef variable: #tempF) expression: (
			ASSend target: (
				ASSend target: (ASSend target: (ASRef variable: #UIManager) selector: #default args: #())
					selector: #request: args: { ASLiteral literal: 'Input temp in F: ' }) selector: #asNumber).
		ASAssign variable: (ASRef variable: #tempC) expression: (
			ASSend target: (
				ASSend target: (ASRef variable: #tempF) selector: #- args: { ASLiteral literal: 32 }
			) selector: #/ args: { ASLiteral literal: 1.8 }).
		ASCascade target: (ASRef variable: #Transcript) sends: { 
			ASSend selector: #show: args: { ASRef variable: #tempC }.
			ASSend selector: #cr args: #()
		}
	}.
	actual := ZagTSNode pythonToZagAST: source.
	self assert: actual equals: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testFloatNode [
	"Ensure a float literal can be converted to Zag properly."
	self assertExpression: '2.0' convertsTo: (ASLiteral literal: 2.0).
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testFor [
	"Tests converting a basic for loop."
	| source expected |
	source := 'for i in c:
	sum += i'.
	expected := ASSend target: (ASRef variable: #c) selector: #do: args: {
		ASBlockNode arguments: { ASRef variable: #i } locals: #() body: {
			ASAssign variable: (ASRef variable: #sum) expression: (
				ASSend target: (ASRef variable: #sum) selector: #+ args: { ASRef variable: #i })}}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testForPass [
	"Tests converting a basic for loop."
	| source expected |
	source := 'for i in c:
	pass'.
	expected := ASSend target: (ASRef variable: #c) selector: #do: args: {
		ASBlockNode arguments: { ASRef variable: #i } locals: #() body: {}}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - full programs' }
PythonConversionTest >> testGuessingGame [
	"Tests converting a simple guessing game program."
	"This is only partially implemented so far."
	| source expected actual |
	source := 'secret = 42
guess = -1
guesses = 7
while guess != secret and guesses > 0:
	guess = int(input("Enter guess: "))
	guesses -= 1'.
	expected := ASMethodNode selector: #main arguments: #() locals: {
		ASRef variable: #secret. ASRef variable: #guess. ASRef variable: #guesses
	} body: {
		ASAssign variable: (ASRef variable: #secret) expression: (ASLiteral literal: 42).
		ASAssign variable: (ASRef variable: #guess) expression: (ASSend target: (ASLiteral literal: 1) selector: #negated args: #()).
		ASAssign variable: (ASRef variable: #guesses) expression: (ASLiteral literal: 7).
		ASSend target: ( ASBlockNode arguments: #() locals: #() body: {
			ASSend target: (
				ASSend target: (ASRef variable: #guess) selector: #~= args: { ASRef variable: #secret }
			) selector: #pythonAnd: args: { ASBlockNode arguments: #() locals: #() body: {
				ASSend target: (ASRef variable: #guesses) selector: #> args: { ASLiteral literal: 0 }
			}}
		}) selector: #whileTrue: args: { ASBlockNode arguments: #() locals: #() body: {
			ASAssign variable: (ASRef variable: #guess) expression: (
				ASSend target: (
					ASSend target: (ASSend target: (ASRef variable: #UIManager) selector: #default args: #())
						selector: #request: args: { ASLiteral literal: 'Enter guess: ' }) selector: #asInteger).
			ASAssign variable: (ASRef variable: #guesses) expression: (
				ASSend target: (ASRef variable: #guesses) selector: #- args: { ASLiteral literal: 1 }
			)
		}}
	}.
	actual := ZagTSNode pythonToZagAST: source.
	self assert: actual equals: expected.
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testIfElif [
	"Tests converting an if statement with an elif block."
	| source expected |
	source := 'if condition1:
	x = 0
elif condition2 == condition3:
	x = 1'.
	expected := ASSend target: (ASArray statements: {
		ASSend target: (ASSend target: (ASRef variable: #condition1) selector: #asPythonBoolean) selector: #-> args: {
			ASBlockNode arguments: #() locals: #() body: {
				ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 0)}}.
		ASSend target: (ASSend target: (ASSend target: (ASRef variable: #condition2) selector: #= args: {ASRef variable: #condition3}) selector: #asPythonBoolean) selector: #-> args: {
			ASBlockNode arguments: #() locals: #() body: {
				ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 1)}}
	}) selector: #switch.
	self assertExpression: source convertsTo: expected "withLocals: #(#x)".
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testIfElifElse [
	"Tests converting an if statement with an elif and else block."
	| source expected |
	source := 'if condition1:
	x = 0
elif condition2 == condition3:
	x = 1
else:
	x = 2'.
	expected := ASSend target: (ASArray statements: {
		ASSend target: (ASSend target: (ASRef variable: #condition1) selector: #asPythonBoolean) selector: #-> args: {
			ASBlockNode arguments: #() locals: #() body: {
				ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 0)}}.
		ASSend target: (ASSend target: (ASSend target: (ASRef variable: #condition2) selector: #= args: {ASRef variable: #condition3}) selector: #asPythonBoolean) selector: #-> args: {
			ASBlockNode arguments: #() locals: #() body: {
				ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 1)}}.
		ASSend target: (ASLiteral literal: true) selector: #-> args: {
			ASBlockNode arguments: #() locals: #() body: {
				ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 2)}}
	}) selector: #switch.
	self assertExpression: source convertsTo: expected "withLocals: #(#x)".
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testIfElse [
	"Tests converting an if statement with an else block."
	| source expected |
	source := 'if condition:
	x = 0
else:
	x = 1'.
	expected := ASSend
		target: (ASSend target: (ASRef variable: #condition) selector: #asPythonBoolean)
		selector: #ifTrue:ifFalse: args: {
		ASBlockNode arguments: #() locals: #() body: {
			ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 0)}.
		ASBlockNode arguments: #() locals: #() body: {
			ASAssign variable: (ASRef variable: #x) expression: (ASLiteral literal: 1)}}.
	self assertExpression: source convertsTo: expected "withLocals: #(#x)".
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testIfExpression [
	self assertExpression: 'a if c else b' convertsTo: (
		ASSend target: (ASRef variable: #c) selector: #ifTrue:ifFalse: args: {
			ASBlockNode locals: #() body: { ASRef variable: #a }.
			ASBlockNode locals: #() body: { ASRef variable: #b }
		}).
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testIfPass [
	"Tests converting an if statement without any elif or else blocks."
	| source expected |
	source := 'if condition:
	pass'.
	expected := ASSend
		target: (ASSend target: (ASRef variable: #condition) selector: #asPythonBoolean)
		selector: #ifTrue: args: { ASBlockNode locals: #() body: {} }.
	self assertExpression: source convertsTo: expected "withLocals: #(#x)".
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIn [
	"Ensure a 'in' expression can be converted to Zag properly."
	| expected source |
	source := 'a in b'.
	expected := ASSend
		target: (ASRef variable: #b)
		selector: #includes:
		args: {ASRef variable: #a}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testInputCall [
	| source expected |
	source := 'input(a)'.
	expected := ASSend
		target: (ASSend target: (ASRef variable: #UIManager) selector: #default args: #())
		selector: #request:
		args: { ASRef variable: #a }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testIntegerNode [
	"Ensure an integer literal can be converted to Zag properly."
	self assertExpression: '2' convertsTo: (ASLiteral literal: 2).
]

{ #category : 'tests - full programs' }
PythonConversionTest >> testInvalidProgram [
	"Test that parsing an invalid program raises an error."
	| invalidSource |
	invalidSource := 'a b'.
	self should: [ ZagTSNode pythonToZagAST: invalidSource ] raise: Error.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIs [
	"Ensure an 'is' expression can be converted to Zag properly."
	| expected source |
	source := 'a is b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #==
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIsNot [
	"Ensure an 'is not' expression can be converted to Zag properly.  Separate because it is a two-word operator."
	| expected source |
	source := 'a is not b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #~~
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda0Arg [
	| source expected |
	source := 'lambda: 1'.
	expected := ASBlockNode
		arguments: #()
		locals: #()
		body: { ASLiteral literal: 1 }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda1Arg [
	| source expected |
	source := 'lambda x: x + 1'.
	expected := ASBlockNode
		arguments: { ASRef variable: #x }
		locals: #()
		body: { ASSend target: (ASRef variable: #x) selector: #+ args: { ASLiteral literal: 1 }}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda2Arg [
	| source expected |
	source := 'lambda a, b: a * b'.
	expected := ASBlockNode
		arguments: { (ASRef variable: #a) . (ASRef variable: #b) }
		locals: #()
		body: { ASSend target: (ASRef variable: #a) selector: #* args: { ASRef variable: #b }}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testMultiOperators [
	"Ensure an expression with multiple operators can be converted to Zag properly."
	| expected source |
	source := 'a + b * c'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #*
			args: {ASRef variable: #c}}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNegation [
	"Ensure an addition expression can be converted to Zag properly."
	| expected source |
	source := '-a'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #negated
		args: #().
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testNoneNode [
	self assertExpression: 'None' convertsTo: (ASLiteral literal: nil). 
]

{ #category : 'tests - literals' }
PythonConversionTest >> testNotImplementedNode [
	self assertExpression: 'NotImplemented' convertsTo: (ASLiteral literal: NotImplemented).
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testNotIn [
	"Ensure a 'not in' expression can be converted to Zag properly.  Included because it has distinct semantics from 'is' and is one operator of two words."
	| expected source |
	source := 'a not in b'.
	expected := ASSend
		target: (ASSend
			target: (ASRef variable: #b)
			selector: #includes:
			args: {ASRef variable: #a})
		selector: #not args: {}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNotOperator [
	"Ensure a 'not' expression can be converted properly."
	| expected source |
	source := 'not a'.
	expected := ASSend target: (ASRef variable: #a) selector: #pythonNot.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testPowers [
	"Ensure an exponent can be converted to Zag properly."
	| expected source |
	source := 'a ** b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #raisedTo:
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testPrintCall [
	| source expected |
	source := 'print(a)'.
	expected := ASCascade target: (ASRef variable: #Transcript) sends: {
		ASSend selector: #show: args: { ASRef variable: #a } .
		ASSend selector: #cr args: #().
	}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testRangeCall2Arg [
	| source expected |
	source := 'range(a, b)'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #toExclusive:
		args: { ASRef variable: #b }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testRangeCall3Arg [
	| source expected |
	source := 'range(a, b, c)'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #toExclusive:by:
		args: { ASRef variable: #b . ASRef variable: #c }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testSetLiteralNode [
	"Tests that set literals and the set() call both produce Smalltalk set literals."
	| expecteds |
	expecteds := { #(1 2 3) . #(1 3 2) . #(2 1 3) . #(2 3 1) . #(3 1 2) . #(3 2 1)}
		collect: [ :list | | statements |
			statements := list collect: [ :each | ASLiteral literal: each ] as: ASArray.
			ASSend target: statements selector: #asSet ].
	self assertExpression: '{1, 2, 3}' convertsToAnyOf: expecteds.
	self assertExpression: 'set([1, 2, 3])' convertsToAnyOf: expecteds.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testStringNode [
	"Ensure a string literal can be converted to Zag properly."
	self assertExpression: '"a"' convertsTo: (ASLiteral literal: 'a').
]

{ #category : 'tests' }
PythonConversionTest >> testVariableNode [
	"Ensure a variable can be converted to Zag properly."
	| expected source |
	source := 'a'.
	expected := ASRef variable: #a.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testWalrus [
	"Ensure a := expression can be converted to Zag properly."
	| expected source |
	source := 'a := b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASRef variable: #b).
	self assertExpression: source convertsTo: expected withLocals: #(#a).
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testWalrusCapture [
	"Ensure capturing the value of a := expression can be converted to Zag properly."
	| expected source |
	source := 'a := (b := c)'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASAssign
			variable: (ASRef variable: #b)
			expression: (ASRef variable: #c)).
	self assertExpression: source convertsTo: expected withLocals: #(#a).
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testWhile [
	"Tests converting a simple while loop."
	| source expected |
	source := 'while x > 0:
	x -= 3'.
	expected := ASSend target: (ASBlockNode arguments: #() locals: #() body: {
		ASSend target: (ASRef variable: #x) selector: #> args: { ASLiteral literal: 0 }
	}) selector: #whileTrue: args: { ASBlockNode arguments: #() locals: #() body: {
		ASAssign variable: (ASRef variable: #x) expression: (
			ASSend target: (ASRef variable: #x) selector: #- args: { ASLiteral literal: 3 })}}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - control flow' }
PythonConversionTest >> testWhilePass [
	"Tests converting a while loop with a pass statement."
	| source expected |
	source := 'while x > 0:
	pass'.
	expected := ASSend target: (ASBlockNode arguments: #() locals: #() body: {
		ASSend target: (ASRef variable: #x) selector: #> args: { ASLiteral literal: 0 }
	}) selector: #whileTrue: args: { ASBlockNode arguments: #() locals: #() body: {}}.
	self assertExpression: source convertsTo: expected.
]
