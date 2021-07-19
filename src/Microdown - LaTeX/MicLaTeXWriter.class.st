Class {
	#name : #MicLaTeXWriter,
	#superclass : #MicDocumentWriter,
	#category : #'Microdown - LaTeX'
}

{ #category : #accessing }
MicLaTeXWriter class >> fileExtension [
	^ 'tex'
]

{ #category : #accessing }
MicLaTeXWriter class >> folderName [
	^ #latex
]

{ #category : #accessing }
MicLaTeXWriter class >> toLatexPath: aString [
	"Replace all (windows style) back slashes in paths by (unix style) forward slashes.
	This is required as path in latex only support unix style pathes like
	
	  /home/xxx
	
	or
	
	  C:/home/xxx
	
	See https://tex.stackexchange.com/questions/9363/how-does-one-insert-a-backslash-or-a-tilde-into-latex
	"
	^ aString copyReplaceAll: '\' with: '/'
]

{ #category : #accessing }
MicLaTeXWriter class >> writerName [
	^ #latex
]

{ #category : #accessing }
MicLaTeXWriter >> canvasClass [
	^ MicLaTeXCanvas initialize
]

{ #category : #templating }
MicLaTeXWriter >> chapterTemplateName [
	
	^ 'latexChapterTemplate'
]

{ #category : #helpers }
MicLaTeXWriter >> createLinkToLabelWithAlias: anInternalLink [
	self halt.
	canvas command
		name: 'hyperref';
		optParameter: [ canvas nextPutAll: anInternalLink anchor ];
		parameter: [ 
					anInternalLink counter isValidCounter
						ifTrue: [ self writeCounter: anInternalLink counter ].
					canvas nextPutAll: anInternalLink alias ]
]

{ #category : #helpers }
MicLaTeXWriter >> createLinkToLabelWithoutAlias: anInternalLink [
	canvas command
		name: 'ref';
		parameter: [ canvas raw: anInternalLink reference ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> getLevelFor: aHeader [
	^ aHeader level
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> getTypeOfSectionFor: aHeader [
	| sections level section |
	sections := self sectioningCommands.
	level := self getLevelFor: aHeader.
	section := sections at: (level min: sections size max: 1).
	^ section
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> includeGraphicsFor: aFigure [
	canvas command
		name: 'includegraphics';
		optParameter: [ self writeGraphicsParametersOfExternalLink: aFigure ];
		parameter: [ canvas raw: (aFigure localFileOrExternalReference) ]
]

{ #category : #protected }
MicLaTeXWriter >> monospaceMacro [
	^ 'code'
]

{ #category : #helpers }
MicLaTeXWriter >> protectUrl: aString [
	^ ((aString copyReplaceAll: '\' with: '\\') copyReplaceAll: '#' with: '\#') copyReplaceAll: '%' with: '\%'
]

{ #category : #helpers }
MicLaTeXWriter >> sectioningCommands [
	^ #('part' 'chapter' 'section' 'subsection' 'subsubsection' 'paragraph' 'subparagraph')
]

{ #category : #protected }
MicLaTeXWriter >> tabularEnvironment [
	^ 'tabular'
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitAnchor: anAnchor [
	canvas command
		name: 'label';
		parameter: anAnchor label
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitAnchorReference: anInternalLink [
	self halt.
	(anInternalLink substring isNil or: [ self configuration separateOutputFiles not ])
		ifTrue: [ 
			anInternalLink children
				ifNotEmpty: [ 
					anInternalLink label isNotNil
						ifTrue: [ self createLinkToLabelWithAlias: anInternalLink ]
						ifFalse: [ 
							MicLinkWarning
								signal:
									(MicTextualMicrodownExporter new write: anInternalLink)
										,
											' will not be render because you export without separate output files. If you want your link to be render add an anchor to the beginning of your file.'.
							canvas nextPutAll: anInternalLink alias ] ]
				ifEmpty: [ 
					anInternalLink reference isNotNil
						ifTrue: [ self createLinkToLabelWithoutAlias: anInternalLink ] ] ]
		ifFalse: [ 
			anInternalLink children
				ifNotEmpty: [ 
					self flag: #todo.	"If we don't render the link we can put it as Footer. We need to do it."				
					canvas nextPutAll: anInternalLink alias ]
				ifEmpty: [ 
					MicLinkWarning
						signal:
							(MicTextualMicrodownExporter new visit: anInternalLink)
								,
									' will not be exported because LaTeX doesn''t support the inter-files links. Please add an Alias to keep this internal link.' ] ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitAnnotatedParagraph: anAnnotatedParagraph [
	"Annotations need to be defined as environments in LaTeX include files (e.g. common.tex)"

	canvas environment
		name: anAnnotatedParagraph annotation;
		with: [ super visitParagraph: anAnnotatedParagraph.
			canvas newLine ]
	"Attention: we do a super call on #visitParagraph: instead of #visitAnnotatedParagraph:. The goal of this hack is to avoid trailing new line characters. This is related to PRLaTeXWriterTest>>#testStrictLineBreaksInAnnotatedParagraphs"
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitBold: aFormat [
	canvas command name: 'textbf'; parameter: [ super visitBold: aFormat ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitCitation: aCitation [
	canvas command
		name: 'cite';
		parameter: (aCitation arguments at: #cite).

]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitCode: aCodeBlock [
	| env parameters |
	parameters := OrderedCollection new.
	
	aCodeBlock hasCaption
		ifTrue: [ parameters add: 'caption={' , (self getStringForAll: aCodeBlock captionElements), '}' ].
		
	 aCodeBlock arguments
		ifNotEmpty:
			[ parameters add: 'language=' , (aCodeBlock language) printString ].
		
	env := canvas environment
		name: 'listing';
		yourself.
	parameters ifNotEmpty: [ env optParameter: parameters asCommaString ].
	env
		with: [ self writeRawDuring: [ canvas lines: aCodeBlock body ].
			canvas newLine ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitFigure: aFigure [
	(aFigure hasCaption not and: [ aFigure hasLabel not ])
		ifTrue: [ 
			self includeGraphicsFor: aFigure.
			^ self ].
	canvas environment
		name: 'figure';
		with:
				[ 
			canvas environment
				name: 'center';
				with:
						[ 
					self includeGraphicsFor: aFigure.
					canvas command
						name: 'caption';
						parameter: [ 
							self
								writeCaptionOfExternalLink: aFigure;
								writeLabelOfExternalLink: aFigure ] ] ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitFootnote: aFootnote [
	canvas command name: 'footnote'; parameter: (aFootnote note)
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitHeader: aHeader [
	| section |
	section := self getTypeOfSectionFor: aHeader.
	canvas command
		name: section;
		parameter: [ super visitHeader: aHeader ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitHorizontalRule: anHorizontalRule [

	canvas newLine; newLine.
	canvas raw: '\rule{\textwidth}{0.1pt}'.
	canvas newLine.
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitItalic: aFormat [
	canvas command name: 'textit'; parameter: [ super visitItalic: aFormat ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitLink: anExternalLink [
	| text reference |
	reference := anExternalLink localFileOrExternalReference.
	text := anExternalLink text.
	(text isEmptyOrNil or: [ reference = text ])
		ifTrue: [ canvas command
				name: 'url';
				parameter: reference ]
		ifFalse: [
			canvas command
				name: 'href';
				parameter: reference;
				parameter: [ canvas nextPutAll: text ].
			canvas command
				name: 'footnote';
				parameter: [ canvas command name: 'url'; parameter: (self protectUrl: reference) ] ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitListItem: anItem [
	canvas command name: 'item'.
	canvas space.
	canvas raw: [ super visitListItem: anItem ].
	canvas newLine
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitMailLink: aLink [
	canvas command
		name: 'href';
		parameter: aLink unscrambledUrl;
		parameter: aLink alias
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitMonospace: aFormat [
	canvas command
		name: self monospaceMacro;
		parameter: [ super visitMonospace: aFormat ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitOrderedList: aList [
	canvas environment
		name: 'enumerate';
		with: [ super visitOrderedList: aList ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitParagraph: aParagraph [
	canvas newLine.
	super visitParagraph: aParagraph.
	canvas newLine.
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitQuote: aPreformatted [
	canvas environment
		name: 'verbatim';
		with: [ 
					self
						writeRawDuring: [ 
							aPreformatted children
								do: [ :child | 
									self visit: child.
									canvas newLine ] ] ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitStrike: aFormat [
	canvas command name: 'sout'; parameter: [ super visitStrike: aFormat ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitTable: aTable [
	| environment |
	environment := canvas environment name: self tabularEnvironment.
	aTable rows size = 0
		ifTrue: [ environment with: [  ].
			^ self ].
	environment parameter: aTable latexSpecification.
	environment
		with: [ canvas command name: 'toprule'.
			canvas newLine.
			aTable rows doWithIndex: [ :row :i | self visitTableRow: row with: aTable hasHeader at: i].
			canvas command name: 'bottomrule'.
			canvas newLine ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitTableCell: aCell [
"	aCell isAligned
		ifFalse: [" self writeTableCellContent: aCell "]
		ifTrue: [ 
			canvas command
				name: 'multicolumn';
				parameter: '1';
				parameter: aCell latexAlignment;
				parameter: [ self writeTableCellContent: aCell ] ]"
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitTableCell: aCell with: aBool [
"	aCell isAligned
		ifFalse: [" self writeTableCellContent: aCell with: aBool "]
		ifTrue: [ 
			canvas command
				name: 'multicolumn';
				parameter: '1';
				parameter: aCell latexAlignment;
				parameter: [ self writeTableCellContent: aCell ] ]"
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitTableRow: aRow [
	self visitAll: aRow children separatedBy: [ canvas raw: ' & ' ].
	canvas
		raw: ' \\';
		newLine.
	aRow isHeading
		ifTrue: [ 
			canvas command name: 'midrule'.
			canvas newLine ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitTableRow: aRow with: aBool at: anIndex [
	aRow do: [ :cell | self visitTableCell: cell with: (aBool and: [ anIndex = 1 ]) ] separatedBy: [ canvas raw: ' & ' ].
	canvas
		raw: ' \\';
		newLine.
	(aBool and: [ anIndex = 1 ])
		ifTrue: [ 
			canvas command name: 'midrule'.
			canvas newLine ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitUnderlineFormat: aFormat [
	canvas command
		name: 'uline';
		parameter: [ super visitUnderlineFormat: aFormat ]
]

{ #category : #'visiting-document' }
MicLaTeXWriter >> visitUnorderedList: aList [
	canvas environment
		name: 'itemize';
		with: [ super visitUnorderedList: aList ]
]

{ #category : #helpers }
MicLaTeXWriter >> writeCaptionOfExternalLink: anExternalLink [
	self visitAll: anExternalLink children
]

{ #category : #helpers }
MicLaTeXWriter >> writeGraphicsParametersOfExternalLink: anExternalLink [

	canvas
		nextPutAll: 'width=';
		nextPutAll:
			((anExternalLink arguments at: 'width' ifAbsent: [ 100 ]) asNumber
			 / 100.0) printString;
		raw: '\textwidth'
]

{ #category : #helpers }
MicLaTeXWriter >> writeLabelOfExternalLink: anExternalLink [

	| label |
	label := anExternalLink arguments
		         at: 'label'
		         ifAbsent: [ anExternalLink localFileOrExternalReference ].
	canvas command
		name: 'label';
		parameter: [ canvas raw: label ]
]

{ #category : #helpers }
MicLaTeXWriter >> writeTableCellContent: aCell [
	^ aCell isHeading
		ifTrue: [ 
			canvas command
				name: 'textbf';
				parameter: [ self visitAll: aCell ] ]
		ifFalse: [ self visitAll: aCell ]
]

{ #category : #helpers }
MicLaTeXWriter >> writeTableCellContent: aCell with: aBool [
	^ aBool
		ifTrue: [ 
			canvas command
				name: 'textbf';
				parameter: [ self visitAll: aCell ] ]
		ifFalse: [ self visitAll: aCell ]
]
