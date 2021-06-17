Class {
	#name : #MicDumperTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'factory',
		'visitor',
		'parser'
	],
	#category : #'Microdown-PrettyPrinter-Tests'
}

{ #category : #tests }
MicDumperTest class >> testParameters [ 
	^ super testParameters
			addCase: { #visitor -> MicDumper };
			addCase: { #visitor -> MicDullDumper };
		yourself.
]

{ #category : #accessing }
MicDumperTest >> factory [ 
	^ factory
]

{ #category : #accessing }
MicDumperTest >> factory: aFactory [
	factory := aFactory
]

{ #category : #running }
MicDumperTest >> setUp [
	super setUp.
	factory := MicMicrodownSnippetFactory new.
	visitor := MicDumper new.
	parser := MicroDownParser new
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintAnchor [
	| micAnchor |
	micAnchor := (parser parse: factory anchorSample) children first.
	self assert: (micAnchor accept: visitor) contents equals: '(MicAnchorBlock new
label: ''test'';
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintCode [
	| micCode |
	micCode := (parser parse: (factory codeblock: 'smalltalk&label=42' body: 'Foo')) children first.
	self assert: (micCode accept: visitor) contents equals: '(MicCodeBlock new
body: ''Foo'';
firstTag: ''smalltalk&label'';
firstLine: ''smalltalk&label=42'';
arguments: {#smalltalk->nil . #label->''42''} asDictionary;
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintComment [
	| micComment |
	micComment := (parser parse: factory commentSample) children first.
	self assert: (micComment accept: visitor) contents equals: '(MicCommentBlock new
text: ''Foo'';
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintEnvironment [
	| micEnvironment |
	self skip.
	micEnvironment := (parser parse: factory environmentSample) children first.
	self assert: (micEnvironment accept: visitor) contents equals: '(MicEnvironmentBlockaddBodyElement: (MicTextBlock new
substring: ''Foo'';
setParser: MicroDownParser new);
arguments: {#value->''aFoo'' . #label->''42''} asDictionary;
 firstLine: ''Foo|value=aFoo&label=42'';
name:''Foo'';
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintHeader [
| micHeader |
	micHeader := (parser parse: factory headerLevel3Sample) children first.
	self assert: (micHeader accept: visitor) contents equals: '(MicHeaderBlock new
addChild: (MicTextBlock new
substring: ''Foo'';
setParser: MicroDownParser new);
level: 3;
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintHorizontalLine [
	| micHorizontalLine |
	micHorizontalLine := (parser parse: factory horizontalLineSample) children first.
	self assert: (micHorizontalLine accept: visitor) contents equals: '(MicHorizontalLineBlock new
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintListItem [
	| micListItem |
	micListItem := (parser parse: factory listMultiSample) children first children first.
	self assert: (micListItem accept: visitor) contents equals: '(MicListItemBlock new
addChild: (MicTextBlock new
substring: ''1'';
setParser: MicroDownParser new);
setParser: MicroDownParser new)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintMath [
	| micMath |
	micMath := (parser parse: factory mathParametersSample) children first.
	self assert: (micMath  accept: visitor) contents equals: '(MicMathBlock new
body: ''Foo'';
firstLine: ''label=42'';
arguments: {''label''->''42''} asDictionary)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintMetaData [
	| micMetaData |
	micMetaData := (parser parse: factory metaDataSample) children first.
	self assert: (micMetaData accept: visitor) contents equals: '(MicMetaDataBlock new
body: ''"author": "Foo"'';
firstLine: '''')'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicAnchorReferenceBlock [
	| micAnchorReference |
	micAnchorReference := (parser parse: factory anchorReferenceSample) children first children first.
	self assert: (micAnchorReference accept: visitor) contents equals: '(MicAnchorReferenceBlock new
substring: ''Foo'')'.


]

{ #category : #'tests-block' }
MicDumperTest >> testPrintMicAnnotated [
	| micAnnotated |
	micAnnotated := (parser parse: factory annotatedSample) children first.
	self assert: (micAnnotated accept: visitor) contents equals: '(MicAnnotatedBlock new
addBodyElement: (MicTextBlock new
substring: ''
Foo '';
setParser: MicroDownParser new);
addBodyElement: (MicItalicFormatBlock new
addChild: (MicTextBlock new
substring: ''bar'';
setParser: MicroDownParser new);
substring: ''bar'';
setParser: MicroDownParser new);
label: ''label'';
setParser: MicroDownParser new)'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicAnnotationBlock [
	| micAnnotation |
	micAnnotation := (parser parse: factory annotationSample) children first children second.
	self assert: (micAnnotation accept: visitor) equals: 'MicAnnotationBlock " Foo | value=aFoo&label=42 "'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicBoldFormatBlock [
	| micBold |
	micBold := (parser parse: factory boldFormatSample) children first children first.
	self assert: (micBold accept: visitor) contents equals: '(MicBoldFormatBlock new
substring: ''Foo'')'

]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicFigureBlock [
	| micFigure |
	micFigure := (parser parse: factory figureSample) children first children first.
	self 
		assert: (micFigure accept: visitor) contents
		equals: 	'(MicFigureBlock new;
parameters: {''label''->''figureTest'' . ''size''->''80''} asDictionary;
addCaptionElement: (MicTextBlock new
substring: ''Foo'';
setParser: MicroDownParser new);
url: ''/anUrl?label=figureTest&size=80'';
substring: ''Foo'')'
	
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicItalicFormatBlock [
	| micItalic |
	micItalic := (parser parse: factory italicFormatSample) children first children first.
	self assert: (micItalic accept: visitor) contents equals: '(MicItalicFormatBlock new
substring: ''Foo'')'

]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicLinkBlock [
	| micLink |
	micLink := (parser parse: factory linkSample) children first children first.
	self assert: (micLink accept: visitor) contents equals: '(MicLinkBlock new;
addCaptionElement: (MicTextBlock new
substring: ''Foo'';
setParser: MicroDownParser new);
url: ''/anUrl'';
substring: ''Foo'')'

]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicMathInlineBlock [
	| micMathInline |
	micMathInline := (parser parse: factory mathInlineSample) children first children first.
	self assert: (micMathInline accept: visitor) contents equals: '(MicMathInlineBlock new
substring: ''V_i = C_0 - C_3'';
setParser: MicroDownParser new)'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicMonospaceFormatBlock [
	| micMonospace |
	micMonospace := (parser parse: factory monospaceFormatSample) children first children first.
	self assert: (micMonospace accept: visitor) contents equals: '(MicMonospaceFormatBlock new
substring: ''Foo'')'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicRawBlock [
	| micRaw |
	micRaw := (parser parse: factory rawFormatSample) children first children second.
	self assert: (micRaw accept: visitor) contents equals: '(MicRawBlock new
substring: ''Foo'')'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicStrikeFormatBlock [
	| micStrike |
	micStrike := (parser parse: factory strikethroughFormatSample) children first children first.
	self assert: (micStrike accept: visitor)contents equals: '(MicStrikeFormatBlock new
substring: ''Foo'')'
]

{ #category : #'tests-inline block' }
MicDumperTest >> testPrintMicTextBlock [
	| micText |
	micText := (parser parse: factory headerLevel3Sample) children first children first.
	self assert: (micText accept: visitor) contents equals: '(MicTextBlock new
substring: ''Foo'')'.

]

{ #category : #'tests-block' }
MicDumperTest >> testPrintOrderedList [
	| micOrderedList |
	micOrderedList := (parser parse: factory orderedListSample) children first.
	self assert: (micOrderedList accept: visitor) equals: 'MicOrderedListBlock'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintParagraph [
	| micParagraph |
	micParagraph := (parser parse: factory paragraphSample) children first.
	self assert: (micParagraph accept: visitor) contents equals: '(MicParagraphBlock new
addChild: (MicTextBlock new
substring: ''Foo'');
substring: ''Foo'')'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintQuote [
	| micQuote |
	micQuote := (parser parse: factory quoteSample) children first.
	self assert: (micQuote accept: visitor) contents equals: '(MicQuoteBlock new
substring: ''Foo'')'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintRoot [
	| micRoot |
	micRoot := (parser parse: factory headerLevel3Sample).
	self assert: (micRoot accept: visitor) contents equals: '(MicRootBlock new
addChild: (MicHeaderBlock new
addChild: (MicTextBlock new
substring: ''Foo'');
level: 3);
)'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintTable [
	| micTable |
	self skip.
	self flag: #fixMe.
	"to fix when MicTable will be fix"
	micTable := (parser parse: factory tableSample).
	self assert: (micTable accept: visitor) equals: 'MicTableBlock'
]

{ #category : #'tests-block' }
MicDumperTest >> testPrintUnorderedList [
	| micUnorderedList |
	micUnorderedList := (parser parse: factory unorderedListSample) children first.
	self assert: (micUnorderedList accept: visitor) equals: 'MicUnorderedListBlock'
]

{ #category : #accessing }
MicDumperTest >> visitor [

	^ visitor
]

{ #category : #accessing }
MicDumperTest >> visitor: anObject [

	visitor := anObject
]
