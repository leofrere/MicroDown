"
may be rename the class later
"
Class {
	#name : #MicInputfileBlock,
	#superclass : #MicAnnotationBlock,
	#category : #'Microdown-Extensions'
}

{ #category : #accessing }
MicInputfileBlock class >> tag [ 
	^ #inputfile
]

{ #category : #visiting }
MicInputfileBlock >> accept: aVisitor [
	aVisitor visitInputfile: self
]

{ #category : #accessing }
MicInputfileBlock >> fileWithConfiguration: aConfiguration [
	"I search my file."
	self flag: 'can be better to use the MicPathResolver'.
	^ aConfiguration baseDirectory resolve: self path
]

{ #category : #testing }
MicInputfileBlock >> isRelativeFilePath [
	^ (self path beginsWith: '/') not
]

{ #category : #accessing }
MicInputfileBlock >> originalPath [
	^ properties at: #originalPath ifAbsent: [ 
		^ self path ]
]

{ #category : #accessing }
MicInputfileBlock >> path [

	^ self arguments at: 'path' 
		ifAbsent: [ ^ 'path is absent' ]
]

{ #category : #accessing }
MicInputfileBlock >> path: aPath [

	arguments at: 'path' put: aPath
]
