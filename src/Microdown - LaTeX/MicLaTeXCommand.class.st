Class {
	#name : #MicLaTeXCommand,
	#superclass : #MicLaTeXBrush,
	#category : #'Microdown - LaTeX'
}

{ #category : #accessing }
MicLaTeXCommand >> name: aString [ 
	stream
		<< $\
		<< aString
]
