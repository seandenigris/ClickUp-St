Class {
	#name : #CuWorkspace,
	#superclass : #CuObject,
	#instVars : [
		'spaces'
	],
	#category : #ClickUp
}

{ #category : #'as yet unclassified' }
CuWorkspace >> allTasks [
	
	^ self spaces flatCollect: [ :space | space allTasks ]
]

{ #category : #accessing }
CuWorkspace >> spaces [

	spaces ifNotNil: [ ^ spaces ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/team/', self id, '/space' 
		do: [ :json |
			spaces := (json at: 'spaces') collect: [ :dict |
				CuSpace 
					fromDictionary: dict 
					withParent: self
					inApplication: self application ] ]
]

{ #category : #accessing }
CuWorkspace >> spacesGtSearchFor: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Spaces';
		priority: 200;
		items: [ self spaces ];
		itemName: #displayString;
		matchSubstrings
]

{ #category : #accessing }
CuWorkspace >> spacesGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Spaces';
		items: [ self spaces ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuWorkspace >> url [

	^ 'https://app.clickup.com' asUrl / self id
]

{ #category : #accessing }
CuWorkspace >> workspace [
	"CuObject compatibility"

	^ self
]
