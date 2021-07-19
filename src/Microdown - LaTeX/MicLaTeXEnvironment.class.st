Class {
	#name : #MicLaTeXEnvironment,
	#superclass : #MicLaTeXBrush,
	#instVars : [
		'name'
	],
	#category : #'Microdown - LaTeX'
}

{ #category : #accessing }
MicLaTeXEnvironment >> name: aString [
	name := aString.
	stream newLine.
	stream << '\begin{' << aString << '}'
]

{ #category : #accessing }
MicLaTeXEnvironment >> with: aBlock [
	stream newLine.
	aBlock value.
	(stream << '\end{' << name)
		<< '}';
		newLine
]
