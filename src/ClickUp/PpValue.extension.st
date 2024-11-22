Extension { #name : #PpValue }

{ #category : #'*ClickUp' }
PpValue >> asClickUpTask [

	^ CuClickUpApplication uniqueInstance
		createTaskInList: self clickUpDefaultList
		fromPpProject: self
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTask [

	self clickUpTaskId ifNil: [ ^ nil ].

	^ CuClickUpApplication uniqueInstance taskWithId: self clickUpTaskId
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskEnsure [

	^ self clickUpTaskExists
		ifTrue: [ self clickUpTask ]
		ifFalse: [ 
			| newTask |
			newTask := self asClickUpTask.
			self clickUpTaskId: newTask id.
			newTask ]
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskExists [

	^ self clickUpTaskId isNotNil
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskGtActionFor: anAction [
	<gtAction>

	self clickUpTask ifNil: [ ^ anAction noAction ].
	
	^ anAction button
		icon: BrGlamorousVectorIcons branching;
		action: [ :button | button phlow spawnObject: 
			self clickUpTask ]
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskId [
	^ self maLazyPropertyUsing: self clickUpTaskIdDescription
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskId: aString [

	^ self
		propertyAt: #clickUpTaskId
		put: aString
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskIdDescription [
	<magritteDescription>
	
	^ MAStringDescription new
			accessor: #clickUpTaskId;
			label: 'ClickUp Task ID';
			priority: 850;
			yourself
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskUrl [

	self clickUpTaskId ifNil: [ ^ nil ].

	^ CuTask urlForId: self clickUpTaskId
]
