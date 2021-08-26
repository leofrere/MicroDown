Class {
	#name : #MicPathResolverTest,
	#superclass : #TestCase,
	#instVars : [
		'resolver',
		'system',
		'parser'
	],
	#category : #'Microdown-ResolvePath-Tests'
}

{ #category : #running }
MicPathResolverTest >> setUp [
	super setUp.
	resolver := MicPathResolver new.
	system := FileSystem memory workingDirectory.
	parser := Microdown new
]

{ #category : #tests }
MicPathResolverTest >> testResolveNotRelativePath [
	
	| text mic urlBefore |
	text := '# section
![caption](file:///folder/image.png)'.

	mic := parser parse: text at: '' asUrl.
	urlBefore := 'file:///folder/image.png'.
	self assert: mic children second children first isRelativeFilePath not.
	
	self assert: mic children second children first isRelativeFilePath not.
	self assert: mic children second children first url asString equals: urlBefore
	
]

{ #category : #tests }
MicPathResolverTest >> testResolveNotRelativePathWithInputfile [
	
	| mic urlBefore |
	mic := parser parse: '?{inputfile|path=/chapters/withStyle.mic}?' at: '' asUrl.
	urlBefore := '/chapters/withStyle.mic'.
	self assert: mic children first children first isRelativeFilePath not.
	self assert: mic children first children first path equals: urlBefore
	
]

{ #category : #tests }
MicPathResolverTest >> testResolveRelativePath [
	| text mic |
	text := '# section
![caption](file://figures/image.png)'.
	mic := parser parse: text at: 'file:///User' asUrl.
	self assert: mic children second children first isRelativeFilePath not.
	self assert: mic children second children first url asString equals: 'file:///User/figures/image.png'
	
]

{ #category : #tests }
MicPathResolverTest >> testResolveRelativePathWithInputfile [
	| mic |
	mic := parser parse: '?{inputfile|path=chapters/withStyle.mic}?' at: '/User' asUrl.
	self assert: mic children first children first isRelativeFilePath not.
	self assert: mic children first children first path equals: '/User/chapters/withStyle.mic'
	
]
