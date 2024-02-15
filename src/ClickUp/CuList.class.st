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
CuList >> parent [

	^ parent ifNil: [ self parent: self getSpace. parent ]
]

{ #category : #accessing }
CuList >> reload [

	self application 
		getListWithId: self id
		jsonDo: [ :json | self rawData: json ].
		
	self tasks: nil
]

{ #category : #accessing }
CuList >> space [

	^ self parent
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
CuList >> tasks: anObject [
	tasks := anObject
]

{ #category : #accessing }
CuList >> tasksGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Tasks';
		items: [ self tasks ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuList >> url [

	^ self workspace url / 'v' / 'li' / self id
]
