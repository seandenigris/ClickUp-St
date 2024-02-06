Class {
	#name : #CuList,
	#superclass : #CuObject,
	#instVars : [
		'tasks'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuList >> tasks [

	tasks ifNotNil: [ ^ tasks ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/list' asUrl / self id / 'task'
		do: [ :json |
			tasks := (json at: 'tasks') collect: [ :dict |
				CuTask fromDictionary: dict forApplication: self application ] ]
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
