Class {
	#name : #MicDumper,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'stream'
	],
	#category : #'Microdown-PrettyPrinter'
}

{ #category : #build }
MicDumper >> blockPrint: aMicText [

	| text |
	text := self classPrint: aMicText.
	text := text , ' "' , aMicText substring , '"'.
	^ text
]

{ #category : #build }
MicDumper >> buildChildAndSubstring: aMicBold [

	stream nextPutAll: '('.
	aMicBold class printOn: stream.
	stream nextPutAll: ' new
'.
	aMicBold children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'substring: ';
		nextPutAll: (self surround: aMicBold text with: '''');
		nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #build }
MicDumper >> buildDictionnary: aDictionnary [

	stream nextPutAll: '{'.
	aDictionnary keysAndValuesDo: [ :k :v | 
		k printOn:stream.
		stream nextPutAll: '->'.
		v printOn: stream.
		k = aDictionnary keys last 
			ifFalse: [ stream nextPutAll: ' . ' ]  ].
	stream nextPutAll: '} asDictionary'
]

{ #category : #build }
MicDumper >> classPrint: aMicFigure [

	^ aMicFigure class asString
]

{ #category : #accessing }
MicDumper >> contents [ 	
	^ stream contents
]

{ #category : #initialization }
MicDumper >> initialize [ 
	super initialize.
	stream := (String new: 10000) writeStream
]

{ #category : #build }
MicDumper >> parametersPrint: aDictionnary [

	| text lastKey |
	lastKey := aDictionnary keys last.
	text := 'parameters:'.
	aDictionnary keysAndValuesDo: [ :k :v |
		text := text , k ,'=', v.
		k = lastKey 
			ifFalse: [ 
				text := text , '&' ]].
	^ text
]

{ #category : #build }
MicDumper >> setParser [

	stream nextPutAll: 'setParser: MicroDownParser new'
]

{ #category : #'writing text' }
MicDumper >> surround: aString with: aStringMarkup [
	^ aStringMarkup , aString , aStringMarkup 
]

{ #category : #'visit-block' }
MicDumper >> visitAnchor: aAnchor [
	stream nextPutAll: '('.
	aAnchor class printOn: stream.
	stream nextPutAll: ' new
';
		nextPutAll: 'label: ';
		nextPutAll: (self surround: aAnchor label with: '''');
		nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitAnchorReference: aMicAnchorReference [

	self buildChildAndSubstring: aMicAnchorReference
]

{ #category : #'visit-block' }
MicDumper >> visitAnnotated: aAnnotated [
	
	stream nextPutAll: '('.
	aAnnotated class printOn: stream.
	stream nextPutAll: ' new
'.
	aAnnotated body do: [ :each | 
		stream nextPutAll: 'addBodyElement: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'label: ';
		nextPutAll: (self surround: aAnnotated label with: '''');
		nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitAnnotation: aMicAnnotation [
	stream nextPutAll: '('.
	aMicAnnotation class printOn: stream.
	stream nextPutAll: ' new
'.
	aMicAnnotation children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'substring: ';
		nextPutAll: (self surround: aMicAnnotation text with: '''');
		nextPutAll: ';
name: ';
		nextPutAll: (self surround: aMicAnnotation name with: '''');
		nextPutAll: ';
arguments: '.
		(self buildDictionnary: aMicAnnotation arguments).
		stream nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitBold: aMicBold [

	self buildChildAndSubstring: aMicBold
]

{ #category : #'visit-block' }
MicDumper >> visitCode: aCode [

	stream nextPutAll: '('.
	aCode class printOn: stream.
	stream nextPutAll: ' new
'.
	aCode children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'body: ';
		nextPutAll: (self surround: aCode body with: '''');
		nextPutAll: ';
isClosed: ';
		nextPutAll: aCode isClosed asString;
		nextPutAll: ';
firstTag: ';
		nextPutAll: (self surround: aCode firstTag with: '''');
		nextPutAll: ';
firstLine: ';
		nextPutAll: (self surround: aCode firstLine with: '''');
		nextPutAll: ';
arguments: '.
	self buildDictionnary: aCode arguments.
	stream nextPutAll: ';
'.
	self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitComment: aComment [

	stream nextPutAll: '('.
	aComment class printOn: stream.
	stream nextPutAll: ' new
'.
	aComment children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'text: ';
		nextPutAll: (self surround: aComment text with: '''');
		nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitEnvironment: aEnvironment [

	stream nextPutAll: '('.
	aEnvironment class printOn: stream.
	aEnvironment bodyElements do: [ :each |
	stream nextPutAll: 'addBodyElement: '.
	each accept: self.
	stream nextPutAll: ';
' ].
	stream nextPutAll: 'arguments: '.
	self buildDictionnary: aEnvironment arguments.
	stream nextPutAll: ';
 firstLine: ';
	nextPutAll: (self surround: aEnvironment firstLine with: '''');
	nextPutAll: ';
name:';
	nextPutAll: (self surround: aEnvironment name with: '''');
	nextPutAll: ';
'.
	self setParser.
	stream nextPutAll: ')'
	
]

{ #category : #'visit-inline block' }
MicDumper >> visitFigure: aMicFigure [

	stream nextPutAll: '('.
	aMicFigure class printOn: stream.
	stream
		nextPutAll: ' new;
';
		nextPutAll: 'parameters: '.
	self buildDictionnary: aMicFigure arguments.
	stream nextPutAll: ';
'.
	aMicFigure captionElements do: [ :each | 
		stream nextPutAll: 'addCaptionElement: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream nextPutAll: 'url: '''.
	aMicFigure url printOn: stream.
	stream
		nextPutAll: ''';
substring: ';
		nextPutAll: (self surround: aMicFigure text with: '''');
		nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitHeader: aHeader [


	stream nextPutAll: '('.
	aHeader class printOn: stream.
	stream nextPutAll: ' new
'.
	aHeader children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'level: '.
		 aHeader level printOn: stream .
		stream nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitHorizontalLine: aHorizontalLine [

	stream nextPutAll: '('.
	aHorizontalLine class printOn: stream.
	stream nextPutAll: ' new
'.
	self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitItalic: aMicItalic [

	self buildChildAndSubstring: aMicItalic
]

{ #category : #'visit-inline block' }
MicDumper >> visitLink: aMicLink [

	stream nextPutAll: '('.
	aMicLink class printOn: stream.
	stream
		nextPutAll: ' new;
'.
	aMicLink captionElements do: [ :each | 
		stream nextPutAll: 'addCaptionElement: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream nextPutAll: 'url: '''.
	aMicLink url printOn: stream.
	stream
		nextPutAll: ''';
substring: ';
		nextPutAll: (self surround: aMicLink text with: '''');
		nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitListItem: aListItem [

	stream nextPutAll: '('.
	aListItem class printOn: stream.
	stream nextPutAll: ' new
'.
	aListItem children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	aListItem textElements do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitMath: aMath [
	stream nextPutAll: '('.
	aMath class printOn: stream.
	stream nextPutAll: ' new
'.
	aMath children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'body: ';
		nextPutAll: (self surround: aMath body with: '''');
		nextPutAll: ';
firstLine: ';
		nextPutAll: (self surround: aMath firstLine with: '''');
		nextPutAll: ';
arguments: '.
		(self buildDictionnary: aMath arguments).
		stream nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitMathInline: aMicMathInline [

	self buildChildAndSubstring: aMicMathInline
]

{ #category : #'visit-block' }
MicDumper >> visitMetaData: aMetaData [

		stream nextPutAll: '('.
	aMetaData class printOn: stream.
	stream nextPutAll: ' new
'.
	aMetaData children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream
		nextPutAll: 'body: ';
		nextPutAll: (self surround: aMetaData body with: '''');
		nextPutAll: ';
firstLine: ';
		nextPutAll: (self surround: aMetaData firstLine with: '''');
		nextPutAll: ';
'.
		self setParser.
		stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitMonospace: aMicMonospace [

	self buildChildAndSubstring: aMicMonospace
]

{ #category : #'visit-block' }
MicDumper >> visitOrderedList: aOrderedList [

	stream nextPutAll: '('.
	aOrderedList class printOn: stream.
	stream nextPutAll: ' new
'.
	aOrderedList children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitParagraph: aParagraph [

	self buildChildAndSubstring: aParagraph
]

{ #category : #'visit-block' }
MicDumper >> visitQuote: aQuote [

	self buildChildAndSubstring: aQuote
]

{ #category : #'visit-inline block' }
MicDumper >> visitRaw: aMicRaw [

	stream nextPutAll: '('.
	aMicRaw class printOn: stream.
	stream nextPutAll: ' new
';
	nextPutAll: 'substring: ';
	nextPutAll: (self surround: aMicRaw substring with: '''');
	nextPutAll: ';
'.
	self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitRoot: aRoot [
	
	stream nextPutAll: '('.
	aRoot class printOn: stream.
	stream nextPutAll: ' new
'.
	aRoot children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	stream nextPutAll: ';
'.
		self setParser.
	stream nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitStrike: aMicStrike [

	self buildChildAndSubstring: aMicStrike
]

{ #category : #'visit-block' }
MicDumper >> visitTable: aTable [

	^ self classPrint: aTable
]

{ #category : #'visit-inline block' }
MicDumper >> visitText: aMicText [

	stream nextPutAll: '('.
	aMicText class printOn: stream.
	stream
		nextPutAll: ' new
';
		nextPutAll: 'substring: ';
		nextPutAll: (self surround: aMicText substring with: '''');
		nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitUnorderedList: aUnorderedList [

	stream nextPutAll: '('.
	aUnorderedList class printOn: stream.
	stream nextPutAll: ' new
'.
	aUnorderedList children do: [ :each | 
		stream nextPutAll: 'addChild: '.
		each accept: self.
		stream nextPutAll: ';
' ].
	self setParser.
	stream nextPutAll: ')'
]
