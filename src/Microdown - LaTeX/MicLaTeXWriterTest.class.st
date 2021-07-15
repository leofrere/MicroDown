Class {
	#name : #MicLaTeXWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'factory',
		'visitor',
		'parser'
	],
	#category : #'Microdown - LaTeX'
}

{ #category : #testing }
MicLaTeXWriterTest class >> isAbstract [
	^ false
]

{ #category : #private }
MicLaTeXWriterTest >> actualClass [
	^ PRLaTeXWriter
]

{ #category : #private }
MicLaTeXWriterTest >> annotationBegin: annotationString [
	^ '\begin{' , annotationString , '}'.
	
]

{ #category : #requirements }
MicLaTeXWriterTest >> boldFoo [
	^ '\textbf{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> citationRepresentation [
	^'\cite{hello}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> dataItemWithBar [
	^ ' bar'
]

{ #category : #requirements }
MicLaTeXWriterTest >> definitionListBegin [
	^ '\begin{description}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> emailToFoo [
	^ '\href{mailto:foo@bar.com'
]

{ #category : #requirements }
MicLaTeXWriterTest >> figureAnchorForPierLogo [
	^ '\label{pierLogo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> figureBegin [
	^ '\begin{figure}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> footnoteBar [
	^ '\footnote{Bar}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> horizontalRule [
	^ '\rule{\textwidth}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> italicFoo [
	^ '\textit{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> level1HeaderBegin [
	^ '\part{'
]

{ #category : #requirements }
MicLaTeXWriterTest >> level1HeaderWithFoo [
	^ '\part{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> level2HeaderBegin [
	^ '\chapter{'
]

{ #category : #requirements }
MicLaTeXWriterTest >> level3HeaderBegin [
	^ '\section{'
]

{ #category : #requirements }
MicLaTeXWriterTest >> listItemWith1 [
	^ '\item 1'
]

{ #category : #requirements }
MicLaTeXWriterTest >> monospaceFoo [
	^ '\code{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> orderedListBegin [
	^ '\begin{enumerate}'
]

{ #category : #accessing }
MicLaTeXWriterTest >> packageNamesUnderTest [
	^ #('Pillar-ExporterLaTeX')
]

{ #category : #requirements }
MicLaTeXWriterTest >> paragraphFoo [
	| newLine |
	newLine := self configuration newLine.
	^ 'foo', newLine
]

{ #category : #requirements }
MicLaTeXWriterTest >> preformattedFooBegin [
	^ '\begin{verbatim}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> preformattedTextFoo [
	^ 'foo'
]

{ #category : #requirements }
MicLaTeXWriterTest >> rawText [
	^ '\textbf{\textit{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> referenceToFigurePierLogo [
	^ '\ref{pierLogo}'
]

{ #category : #'requirement-InternalLinks' }
MicLaTeXWriterTest >> resultWithRefWithAnchorWithSeparateOutputFiles [
	^ ''
]

{ #category : #'requirement-InternalLinks' }
MicLaTeXWriterTest >> resultWithRefWithoutAnchorWithSeparateOutputFiles [
	^ ''
]

{ #category : #'requirement-InternalLinks' }
MicLaTeXWriterTest >> resultWithoutAliasWithoutRefWithAnchorWithSeparateOutputFiles [
	^ '\ref{foo}'
]

{ #category : #'requirement-InternalLinks' }
MicLaTeXWriterTest >> resultWithoutRefWithAnchorWithSeparateOutputFiles [
	^ '\hyperref[foo]'
]

{ #category : #requirements }
MicLaTeXWriterTest >> scriptAnchorForMyScript [
	^ 'label=myScript'
]

{ #category : #requirements }
MicLaTeXWriterTest >> scriptWithCaptionBegin [
	^ '\begin{listing}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> scriptWithoutCaptionBegin [
	^ '\begin{listing}'
]

{ #category : #running }
MicLaTeXWriterTest >> setUp [
	super setUp.
	factory := MicMicrodownSnippetFactory new.
	parser := MicroDownParser new.
	visitor := MicLaTeXWriter new
]

{ #category : #requirements }
MicLaTeXWriterTest >> strikethroughFoo [
	^ '\sout{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> subscriptFoo [
	^ '\textsubscript{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> superscriptFoo [
	^ '\textsuperscript{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> tableBegin [
	^ '\begin{tabular}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> tableCellWithFoo [
	^ 'foo'
]

{ #category : #requirements }
MicLaTeXWriterTest >> tableCellWithHeadingFoo [
	^ '\textbf{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> tableRow [
	^ '\\'
]

{ #category : #requirements }
MicLaTeXWriterTest >> termItemWithFoo [
	^ '\item[foo]'
]

{ #category : #tests }
MicLaTeXWriterTest >> testAnchor [
	| item |
	item := PRAnchor new name: 'foo'.
	self assertWriting: item includesText: '\label{foo}'
]

{ #category : #'tests - format' }
MicLaTeXWriterTest >> testBold [
	| mic |
	mic := parser parse: factory boldFormatSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
\textbf{Foo}
'
]

{ #category : #'tests - codeblock' }
MicLaTeXWriterTest >> testCodeblock [
	| mic |
	mic := parser parse: (factory codeblockNoParamBody: 'this is a code').
	self assert: (visitor visit: mic) contents equals: '
\begin{listing}
this is a code
\end{listing}
'
]

{ #category : #'tests - codeblock' }
MicLaTeXWriterTest >> testCodeblockWithCaption [
	| mic |
	mic := parser parse: (factory codeblock: 'caption=Pharo is **cool**' body: 'this is a code').
	self assert: (visitor visit: mic) contents equals: '
\begin{listing}[caption={Pharo is \textbf{cool}}, language=''caption'']
this is a code
\end{listing}
'
]

{ #category : #'tests - codeblock' }
MicLaTeXWriterTest >> testCodeblockWithParameters [
	| mic |
	mic := parser parse: (factory codeblock: 'language=Smalltalk&size=42' body: 'this is a code').
	self assert: (visitor visit: mic) contents equals: '
\begin{listing}[language=''Smalltalk'']
this is a code
\end{listing}
'
]

{ #category : #requirements }
MicLaTeXWriterTest >> testExportCitation [

	| item |
	item := PRDocument new
		add: (PRCitation ref: 'hello');
		yourself.
	self
		assertWriting: item
		includesText: self citationRepresentation.
]

{ #category : #'tests-internalLinks' }
MicLaTeXWriterTest >> testExternalLinkWithCaptionShouldPrintUrlAsFootnote [
	| link |
	link := self addText: 'Pharo' to: (PRExternalLink reference: 'http://www.pharo.org').
	self assertWriting: link includesText: '\href{http://www.pharo.org}{Pharo}\footnote{\url{http://www.pharo.org}}'
]

{ #category : #'tests-internalLinks' }
MicLaTeXWriterTest >> testExternalLinkWithCaptionShouldProtectUrlInFootnotes [
	| link |
	link := self addText: 'Launcher' to: (PRExternalLink reference: 'http://www.smalltalkhub.com/#!/~Pharo/PharoLauncher').
	self assertWriting: link includesText: '\footnote{\url{http://www.smalltalkhub.com/\#!/~Pharo/PharoLauncher}}'
]

{ #category : #'tests - references' }
MicLaTeXWriterTest >> testFigure [
	| mic |
	mic := parser parse: factory figureSample.
	self assert: (visitor visit: mic) contents equals: '

\begin{figure}

\begin{center}
\includegraphics[width=1.0\textwidth]{/anUrl?label=figureTest&size=80}\caption{\label{figureTest}}\end{center}
\end{figure}

'
]

{ #category : #'tests - references' }
MicLaTeXWriterTest >> testFigureBold [
	| mic |
	mic := parser parse: factory figureBoldSample.
	self assert: (visitor visit: mic) contents equals: '

\begin{figure}

\begin{center}
\includegraphics[width=1.0\textwidth]{/anUrl?label=figureTest&size=80}\caption{\textbf{Foo}\label{figureTest}}\end{center}
\end{figure}

'
]

{ #category : #tests }
MicLaTeXWriterTest >> testFigureCaptionWithNonTextChildren [
	| item |
	item := PRFigure new
		reference: 'file://picture.png';
		add: (self addText: 'foo' to: PRBoldFormat new);
		yourself.
	self assertWriting: item includesText: self boldFoo
]

{ #category : #tests }
MicLaTeXWriterTest >> testFigureLabelNotEscaped [
	| item |
	item := PRFigure new
		reference: 'file://picture.png';
		label: 'a_b';
		yourself.
	self assertWriting: item includesText: 'a_b'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel1LaTeX [
	| mic |
	mic := parser parse: factory headerLevel1Sample.
	self assert: (visitor visit: mic) contents equals: '\part{Foo}'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel2LaTeX [
	| mic |
	mic := parser parse: factory headerLevel2Sample.
	self assert: (visitor visit: mic) contents equals: '\chapter{Foo}'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel3LaTeX [
	| mic |
	mic := parser parse: factory headerLevel3Sample.
	self assert: (visitor visit: mic) contents equals: '\section{Foo}'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel4LaTeX [
	| mic |
	mic := parser parse: factory headerLevel4Sample.
	self assert: (visitor visit: mic) contents equals: '\subsection{Foo}'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel5LaTeX [
	| mic |
	mic := parser parse: factory headerLevel5Sample.
	self assert: (visitor visit: mic) contents equals: '\subsubsection{Foo}'
]

{ #category : #'tests - header' }
MicLaTeXWriterTest >> testHeaderLevel6LaTeX [
	| mic |
	mic := parser parse: factory headerLevel6Sample.
	self assert: (visitor visit: mic) contents equals: '\paragraph{Foo}'
]

{ #category : #'tests-internalLinks' }
MicLaTeXWriterTest >> testInternalLinkWithoutAliasWithRefWithAncorWithSeparateOutputFiles [
	| item resultString |
	item := PRParagraph new
		add: (PRAnchor named: 'foo');
		add: (PRInternalLink reference: 'ref@foo');
		yourself.
	self should: [ resultString := self writeWithSeparateOutputFiles: item ] raise: PRLinkWarning.
	[ resultString := self writeWithSeparateOutputFiles: item ]
		on: PRLinkWarning
		do: [ :w | w resume ].
	self resultWithRefWithAnchorWithSeparateOutputFiles = ''
		ifFalse: [ self assert: (resultString includesSubstring: self resultWithRefWithAnchorWithSeparateOutputFiles) ]
]

{ #category : #'tests-internalLinks' }
MicLaTeXWriterTest >> testInternalLinkWithoutAliasWithReferenceWithoutAnchorWithSeparateOutputFiles [
	| item resultString |
	item := PRParagraph new
		add: (PRAnchor named: 'foo');
		add: (PRInternalLink reference: 'ref');
		yourself.
	self should: [ resultString := self writeWithSeparateOutputFiles: item ] raise: PRLinkWarning.
	[ resultString := self writeWithSeparateOutputFiles: item ]
		on: PRLinkWarning
		do: [ :w | w resume ].
	self resultWithRefWithoutAnchorWithSeparateOutputFiles = ''
		ifFalse: [ self assert: (resultString includesSubstring: self resultWithRefWithoutAnchorWithSeparateOutputFiles) ]
]

{ #category : #'tests - format' }
MicLaTeXWriterTest >> testItalic [
	| mic |
	mic := parser parse: factory italicFormatSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
\textit{Foo}
'
]

{ #category : #tests }
MicLaTeXWriterTest >> testLinksWithBadCharactersInCaption [
	| item url caption |
	url := 'http://www.pharo.org'.
	caption := 'bad chars #_'.
	item := PRExternalLink new
		reference: url;
		add: (PRText content: caption);
		yourself.
	self assertWriting: item includesText: 'bad chars \#\_'
]

{ #category : #tests }
MicLaTeXWriterTest >> testLinksWithEitherHrefOrUrl [
	| item url caption |
	url := 'http://www.pharo.org#foo'.
	caption := 'some caption'.
	item := PRExternalLink new reference: url.
	self assertWriting: item includesText: '\url{' , url , '}'.
	item := PRExternalLink new
		reference: url;
		add: (PRText content: caption);
		yourself.
	self assertWriting: item includesText: '\href{' , url , '}{' , caption , '}'
]

{ #category : #'tests - format' }
MicLaTeXWriterTest >> testMonospace [
	| mic |
	mic := parser parse: factory monospaceFormatSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
\code{Foo}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testOrderedList [
	| mic |
	mic := parser parse: factory orderedListWithTwoItemsSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{enumerate}
\item first
\item second
\end{enumerate}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testOrderedListBold [
	| mic |
	mic := parser parse: factory orderedListWithTwoItemsBoldSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{enumerate}
\item \textbf{first}
\item second
\end{enumerate}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testOrderedListNested [
	| mic |
	mic := parser parse: factory orderedListWithTwoItemsNestedSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{enumerate}
\item \textbf{\textit{first}}
\item second
\end{enumerate}
'
]

{ #category : #'tests - paragraph' }
MicLaTeXWriterTest >> testParagraph [
	| mic |
	mic := parser parse: factory paragraphSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
Foo
'
]

{ #category : #'tests - paragraph' }
MicLaTeXWriterTest >> testParagraphWithBold [
	| mic |
	mic := parser parse: factory paragraphBoldSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
this is a \textbf{paragraph}
'
]

{ #category : #'tests - paragraph' }
MicLaTeXWriterTest >> testParagraphWithItalic [
	| mic |
	mic := parser parse: factory paragraphItalicSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
this is a \textit{paragraph}
'
]

{ #category : #'tests - paragraph' }
MicLaTeXWriterTest >> testParagraphWithMonospace [
	| mic |
	mic := parser parse: factory paragraphMonospaceSample.
	self assert: (visitor visit: mic) contents equals: '
this is a \code{paragraph}
'
]

{ #category : #'tests - paragraph' }
MicLaTeXWriterTest >> testParagraphWithNested [
	| mic |
	mic := parser parse: factory paragraphNestedSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
this is a \textbf{\textit{paragraph}}
'
]

{ #category : #tests }
MicLaTeXWriterTest >> testPreformattedExportsToUnprotectedVerbatim [
	"Special characters in a Pillar preformattted group should not be protected by backslashes because they are exported in a verbatim LaTeX environment."

	| item |
	item := PRPreformatted with: (PRText content: '[[[').
	self
		assertWriting: item
		includesText: self preformattedFooBegin , self configuration newLine , '[[[' , self configuration newLine
]

{ #category : #tests }
MicLaTeXWriterTest >> testQuote [
	| mic |
	mic := parser parse: (factory quoteSample).
	self assert: (visitor visit: mic) contents equals: '
\begin{verbatim}
Foo
\end{verbatim}
'
]

{ #category : #tests }
MicLaTeXWriterTest >> testReferencesToSectionsAreNotEscaped [
	|item|
	item := PRInternalLink reference: '@a_section_somewhere'.
	self assertWriting: item includesText: 'a_section_somewhere'
]

{ #category : #tests }
MicLaTeXWriterTest >> testScriptWithCorrectNewLines [
	| item |
	item := (PRCodeblock content: 'foo')
		label: 'myScript';
		caption: 'a caption';
		yourself.
	self
		assertWriting: item
		includesText:
			self configuration newLine , 'foo' , self configuration newLine , '\end{'
]

{ #category : #tests }
MicLaTeXWriterTest >> testStrictLineBreaksInAnnotatedParagraphs [
	| item lineBreak |
	item := self
		addText: 'Blah'
		to:
			(PRAnnotatedParagraph new
				annotation: 'note';
				yourself).
	lineBreak := self configuration newLine.
	self assertWriting: item includesText: '\begin{note}' , lineBreak , 'Blah' , lineBreak , '\end{note}' , lineBreak
]

{ #category : #'tests - format' }
MicLaTeXWriterTest >> testStrike [
	| mic |
	mic := parser parse: factory strikethroughFormatSample.
	visitor visit: mic.
	self assert: visitor contents equals: '
\sout{Foo}
'
]

{ #category : #tests }
MicLaTeXWriterTest >> testTable [
	| mic |
	mic := parser parse: (factory tableSample).
	self assert: (visitor visit: mic) contents equals: '
\begin{tabular}{ll}
\toprule
\textbf{aaab} & \textbf{jkhjh} \\
\midrule
bar & rab \\
\bottomrule
\end{tabular}
'
]

{ #category : #tests }
MicLaTeXWriterTest >> testTableWhithoutHeader [
	| mic |
	mic := parser parse: (factory simpleTableWithoutHeaderTable).
	self assert: (visitor visit: mic) contents equals: '
\begin{tabular}{ll}
\toprule
aaab & jkhjh \\
bar & rab \\
\bottomrule
\end{tabular}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testUnorderedList [
	| mic |
	mic := parser parse: factory unorderedListWithTwoItemsSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{itemize}
\item Foo
\item Bar
\end{itemize}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testUnorderedListBold [
	| mic |
	mic := parser parse: factory unorderedListWithTwoItemsBoldSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{itemize}
\item \textbf{Foo}
\item Bar
\end{itemize}
'
]

{ #category : #'tests - lists' }
MicLaTeXWriterTest >> testUnorderedListNested [
	| mic |
	mic := parser parse: factory unorderedListWithTwoItemsNestedSample.
	self assert: (visitor visit: mic) contents equals: '
\begin{itemize}
\item \sout{\textit{Foo}}
\item Bar
\end{itemize}
'
]

{ #category : #'tests-internalLinks' }
MicLaTeXWriterTest >> testUrlsAreProtected [
	| writer |
	writer := self createWriterOn: String new.
	self assert: (writer protectUrl: '#') equals: '\#'.
	self assert: (writer protectUrl: '~') equals: '~'.
	self assert: (writer protectUrl: '&') equals: '&'.
	self assert: (writer protectUrl: '%') equals: '\%'.
	self assert: (writer protectUrl: '\') equals: '\\'.
	self assert: (writer protectUrl: '\~#%') equals: '\\~\#\%'.
]

{ #category : #requirements }
MicLaTeXWriterTest >> underlineFoo [
	^ '\uline{foo}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> unorderedListBegin [
	^ '\begin{itemize}'
]

{ #category : #requirements }
MicLaTeXWriterTest >> widthFor50percents [
	^ '0.5'
]
