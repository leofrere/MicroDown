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

{ #category : #'visit-inline block' }
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
		nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> buildDictionnary: aDictionnary [

	stream nextPutAll: '{'.
	aDictionnary keysAndValuesDo: [ :k :v | 
		k printOn:stream.
		stream nextPutAll: '->'.
		v printOn: stream.
		k = aDictionnary keys last 
			ifFalse: [ stream nextPutAll: ' . ' ]  ].
	stream nextPutAll: '}'
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

{ #category : #'writing text' }
MicDumper >> surround: aString with: aStringMarkup [
	^ aStringMarkup , aString , aStringMarkup 
]

{ #category : #'visit-block' }
MicDumper >> visitAnchor: aAnchor [

	stream nextPutAll: '('.
	aAnchor class printOn: stream.
	stream nextPutAll: ' new
'.
	stream
		nextPutAll: 'label: ';
		nextPutAll: (self surround: aAnchor label with: '''');
		nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitAnchorReference: aMicAnchorReference [

	self buildChildAndSubstring: aMicAnchorReference
]

{ #category : #'visit-block' }
MicDumper >> visitAnnotated: aAnnotated [

	^ self classPrint: aAnnotated
]

{ #category : #'visit-inline block' }
MicDumper >> visitAnnotation: aMicAnnotation [
	"arguments with parameters is nil like the name"
	"| text |
	text := aMicAnnotation class asString , String space.
	text := text , (self parametersPrint: aMicAnnotation parameters asDictionary).
	text := text , ' ""' , aMicAnnotation name , '""'."
	^ self blockPrint: aMicAnnotation
	
]

{ #category : #'visit-inline block' }
MicDumper >> visitBold: aMicBold [

	self buildChildAndSubstring: aMicBold
]

{ #category : #'visit-block' }
MicDumper >> visitCode: aCode [

	| text |
	text := self classPrint: aCode.
	text := text , ' parameters:' , aCode firstLine.
	text := text , ' "' , aCode body , '"'.
	^ text
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
		nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitEnvironment: aEnvironment [

	| text |
	text := (self classPrint: aEnvironment) , String space.
	text := text , (self parametersPrint: aEnvironment arguments asDictionary).
	text := text , ' "' , aEnvironment name , '"'.
	^ text
]

{ #category : #'visit-inline block' }
MicDumper >> visitFigure: aMicFigure [

	| text |
	text := (self classPrint: aMicFigure) , String space.
	text := text
	        , (self parametersPrint: aMicFigure parameters asDictionary).
	text := text , ' url:' , aMicFigure url asString.
	text := text , ' "' , aMicFigure substring , '"'.
	^ text
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
		stream nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitHorizontalLine: aHorizontalLine [

	stream nextPutAll: '('.
	aHorizontalLine class printOn: stream.
	stream nextPutAll: ' new';
	nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitItalic: aMicItalic [

	self buildChildAndSubstring: aMicItalic
]

{ #category : #'visit-inline block' }
MicDumper >> visitLink: aMicLink [

	| text |
	text := self classPrint: aMicLink.
	text := text , ' url:' , aMicLink url asString , ' "'
	        , aMicLink substring , '"'.
	^ text
]

{ #category : #'visit-block' }
MicDumper >> visitListItem: aListItem [

	| text |
	text := self classPrint: aListItem.
	text := text , ' "' , aListItem text , '"'.
	^ text
]

{ #category : #'visit-block' }
MicDumper >> visitMath: aMath [

	| text |
	text := (self classPrint: aMath) , String space.
	text := text , (self parametersPrint: aMath arguments asDictionary).
	text := text , ' "' , aMath body , '"'.
	^ text
]

{ #category : #'visit-inline block' }
MicDumper >> visitMathInline: aMicMathInline [

	^ self blockPrint: aMicMathInline
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
		nextPutAll: ')'
]

{ #category : #'visit-inline block' }
MicDumper >> visitMonospace: aMicMonospace [

	self buildChildAndSubstring: aMicMonospace
]

{ #category : #'visit-block' }
MicDumper >> visitOrderedList: aOrderedList [

	^ self classPrint: aOrderedList
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
	nextPutAll: ')'
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
	stream nextPutAll: ' new
';
	nextPutAll: 'substring: ';
	nextPutAll: (self surround: aMicText substring with: '''');
	nextPutAll: ')'
]

{ #category : #'visit-block' }
MicDumper >> visitUnorderedList: aUnorderedList [

	^ self classPrint: aUnorderedList
]
