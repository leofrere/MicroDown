"
`MicPathResolver` uses the originPath of the figure to create an absolutePath for the figure.
The originPath is defined when we use the `MicroDownParser>>#parseFile:` else originPath takes per default the FileSystem workingDirectory.
The `MicPathResolver` replaces the  url by an url which contains an absolute file path and it keeps the original url in originUrl in the properties of figure
"
Class {
	#name : #MicPathResolver,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'url'
	],
	#category : #'Microdown-ResolvePath'
}

{ #category : #accessing }
MicPathResolver >> url [
	^ url
]

{ #category : #accessing }
MicPathResolver >> url: anUrl [
	url := anUrl
]

{ #category : #visiting }
MicPathResolver >> visitFigure: aFigure [
	| originUrl urlSave |
	originUrl := aFigure originUrl.
	urlSave := url copy.
	aFigure url: originUrl.
	(aFigure url scheme = 'file' and: [ aFigure isRelativeFilePath  ])
			ifTrue: [
				aFigure url asUrl host ifNotNil: [ url addPathSegment: aFigure url asUrl host ].
				url addPathSegments: aFigure url asUrl segments.
				aFigure url: url ].
	aFigure propertyAt: #originUrl put: originUrl.
	url := urlSave.
	^ aFigure
]

{ #category : #visiting }
MicPathResolver >> visitInputfile: anInputFile [
	self flag: 'see how we change in MicFileIncluder'.
	"anInputFile path: (anInputFile propertyAt: #originalPath  ifAbsent: [ 
		anInputFile propertyAt: #originalPath put: anInputFile path ]).
	 anInputFile isRelativeFilePath
			ifTrue: [ anInputFile path: (url asString , '/' , anInputFile originalPath) ]."
	^ anInputFile
]
