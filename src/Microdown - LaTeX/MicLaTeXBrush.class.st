Class {
	#name : #MicLaTeXBrush,
	#superclass : #MicExportBrush,
	#category : #'Microdown - LaTeX'
}

{ #category : #accessing }
MicLaTeXBrush >> optParameter: aString [ 
	stream
		<< $[
		<< aString
		<< $]
]

{ #category : #accessing }
MicLaTeXBrush >> parameter: aString [ 
	stream
		<< ${
		<< aString
		<< $}
]
