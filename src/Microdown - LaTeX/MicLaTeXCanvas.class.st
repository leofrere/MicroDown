Class {
	#name : #MicLaTeXCanvas,
	#superclass : #MicExportCanvas,
	#classVars : [
		'LatexCharacters'
	],
	#category : #'Microdown - LaTeX'
}

{ #category : #tags }
MicLaTeXCanvas >> command [
	^ self brush: PRLaTeXCommand new
]

{ #category : #tags }
MicLaTeXCanvas >> environment [
	^ self brush: PRLaTeXEnvironment new
]

{ #category : #'writing text' }
MicLaTeXCanvas >> nextPut: aCharacter [
	(LatexCharacters at: aCharacter ifAbsent: nil)
		ifNil: [ super nextPut: aCharacter ]
		ifNotNil: [ :string | self raw: string ]
]
