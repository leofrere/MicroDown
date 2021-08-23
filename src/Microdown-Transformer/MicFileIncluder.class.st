"
MicFileInclusion replace the MicInputfileBlock by the nodes obtain during the parse of file.

For a file name example.mic which contains :

# Foo

this is a paragraph

```
 this is a code
```

the transformer transform `?{fileinput?path=example.mic}?` by : 

# Foo

this is a paragraph

```
 this is a code
```

And if the path does not exist the transformer do nothing
"
Class {
	#name : #MicFileIncluder,
	#superclass : #MicNodeTransformer,
	#instVars : [
		'shouldTransform',
		'input',
		'goal',
		'expansionTask',
		'inProcessFiles'
	],
	#category : #'Microdown-Transformer'
}

{ #category : #configuration }
MicFileIncluder >> doNotTransform [
	shouldTransform := false
]

{ #category : #accessing }
MicFileIncluder >> inProcessFiles: aCollection [ 
	inProcessFiles := aCollection
]

{ #category : #initialization }
MicFileIncluder >> initialize [

	super initialize.
	inProcessFiles := #()
]

{ #category : #'visiting-document' }
MicFileIncluder >> input: anInputDocument [

	input := anInputDocument
]

{ #category : #testing }
MicFileIncluder >> shouldTransform [
	^ shouldTransform ifNil: [ shouldTransform := true ]
]

{ #category : #'visiting-document' }
MicFileIncluder >> visitInputfile: anInputFileAnnotation [
	"I load the file and if the file exist I replace the node of the annotation by the content of the file."
	
	| includedFile microdownAST |
	includedFile := anInputFileAnnotation originPath / anInputFileAnnotation path.
	includedFile ifExists:[
		microdownAST := (MicInputDocument forFile: includedFile) parsedDocument.
	
	"Execute a file inclusion step recursively" 
	self class new visit: microdownAST.
	
	self replaceCurrentNodeBy: microdownAST children]
	
]
