Class {
	#name : #MicMicrodownInputDocument,
	#superclass : #MicInputDocument,
	#category : #'Microdown-Transformer'
}

{ #category : #registration }
MicMicrodownInputDocument class >> doesHandleExtension: anExtension [

	^ anExtension = 'mic'
]

{ #category : #accessing }
MicMicrodownInputDocument >> parsedDocument [

	^ self parserClass new parseFile: file
]

{ #category : #accessing }
MicMicrodownInputDocument >> parserClass [
	
	^ MicAbstractBlock new parserClass
]
