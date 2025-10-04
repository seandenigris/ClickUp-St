Class {
	#name : #CuWorkspace,
	#superclass : #CuObject,
	#instVars : [
		'spaces',
		'sharedLists'
	],
	#category : #ClickUp
}

{ #category : #'as yet unclassified' }
CuWorkspace >> allTasks [
	
	^ OrderedCollection streamContents: [ :str |
		self spaces do: [ :space | str nextPutAll: space allTasks ].
		self sharedLists do: [ :list | str nextPutAll: list allTasks ] ].
]

{ #category : #'as yet unclassified' }
CuWorkspace >> listWithId: aString [ 
	
	^ self spaces do: [ :ws |
		(ws listWithId: aString)
			ifNotNil: [ :aList | ^ aList ] ]
]

{ #category : #'as yet unclassified' }
CuWorkspace >> reload [

	sharedLists := nil.
	spaces := nil.
	self sharedLists; spaces.
]

{ #category : #'as yet unclassified' }
CuWorkspace >> sharedHierarchy [

	^ self application
		getSharedHierarchyForTeamWithId: self id 
		jsonDo: [ :json | json ]
]

{ #category : #'as yet unclassified' }
CuWorkspace >> sharedLists [
	"This part of the model is not fleshed out yet, so the API may change. Possibly there may be a virtual 'shared with me' space for uniformity, but as we only need to implement shared lists (not tasks or folders), we will defer thinking that through"

	sharedLists ifNotNil: [ ^ sharedLists ].
	
	^ sharedLists := self application
		getSharedHierarchyForTeamWithId: self id 
		jsonDo: [ :json | 
			| listArray |
			listArray := (json at: 'shared') at: 'lists'.
			listArray collect: [ :dict |
				CuList
					fromDictionary: dict
					withParent: self 
					inApplication: self application ] ]
]

{ #category : #'as yet unclassified' }
CuWorkspace >> sharedListsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Shared Lists';
		priority: 50;
		items: [ self sharedLists ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
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
		priority: 25;
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
