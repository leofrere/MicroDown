Extension { #name : #MicTableBlock }

{ #category : #'*Microdown - LaTeX' }
MicTableBlock >> latexSpecification [
	^ String new: rows first size withAll: $l
]
