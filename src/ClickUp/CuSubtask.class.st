Class {
	#name : #CuSubtask,
	#superclass : #CuTask,
	#category : #ClickUp
}

{ #category : #accessing }
CuSubtask class >> fromId: aString withParent: aCuTask inApplication: anApplication [

	^ anApplication 
		getTaskWithId: aString 
		jsonDo: [ :aDictionary |
			self
				fromDictionary: aDictionary
				withParent: aCuTask
				inApplication: anApplication ]
]
