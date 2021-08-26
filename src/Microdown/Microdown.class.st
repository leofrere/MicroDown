Class {
	#name : #Microdown,
	#superclass : #Object,
	#instVars : [
		'parser'
	],
	#category : #'Microdown-Parser'
}

{ #category : #initialize }
Microdown >> initialize [
	super initialize.
	parser := MicroDownParser new
]

{ #category : #accessing }
Microdown >> parse: aStreamOrString at: anUrl [
	| mic resolver |
	mic := parser parse: aStreamOrString.
	resolver := MicPathResolver new.
	resolver url: anUrl.
	resolver visit: mic.
	^ mic
	
]
