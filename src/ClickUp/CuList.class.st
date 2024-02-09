Class {
	#name : #CuList,
	#superclass : #CuObject,
	#instVars : [
		'tasks'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuList >> allTasks [
	"CuObject compatibility"
	
	^ self tasks
]

{ #category : #accessing }
CuList >> getSpace [

	^ self
		rawDataAt: 'space'
		reader: [ :dict |
			self application spaceWithId: (dict at: 'id' ) ]
]

{ #category : #accessing }
CuList >> space [

	^ self
		rawDataAt: 'space'
		reader: [ :dict |
			self application spaceWithId: (dict at: 'id' ) ]
]

{ #category : #accessing }
CuList >> tasks [

	tasks ifNotNil: [ ^ tasks ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/list' asUrl / self id / 'task'
		do: [ :json |
			tasks := (json at: 'tasks') collect: [ :dict |
				CuTask
					fromDictionary: dict 
					withParent: self
					inApplication: self application ] ]
]

{ #category : #accessing }
CuList >> tasksGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Tasks';
		items: [ self tasks ];
		itemText: #displayString;
		yourself
]

{ #category : #accessing }
CuList >> url [

	^ self workspace url / 'v' / 'li' / self id
]
