Class {
	#name : #CuSpace,
	#superclass : #CuObject,
	#instVars : [
		'lists',
		'folders'
	],
	#classInstVars : [
		'apiToken',
		'client'
	],
	#category : #ClickUp
}

{ #category : #'CuObject - accessing' }
CuSpace >> allTasks [
	
	^ OrderedCollection streamContents: [ :str |
		self folders do: [ :folder |
			str nextPutAll: folder allTasks ].
			
		self lists do: [ :list |
			str nextPutAll: list tasks ] ]
]

{ #category : #accessing }
CuSpace >> baseApiUrl [

	^ 'https://api.clickup.com/api/v2/space' asUrl
]

{ #category : #accessing }
CuSpace >> folders [

	folders ifNotNil: [ ^ folders ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/space' asUrl / self id / 'folder'
		do: [ :json |
			folders := (json at: 'folders') collect: [ :dict |
				CuFolder 
					fromDictionary: dict 
					withParent: self
					inApplication: self application ] ]
]

{ #category : #accessing }
CuSpace >> folders: anObject [
	folders := anObject
]

{ #category : #accessing }
CuSpace >> foldersGtSearchFor: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Folders';
		priority: 300;
		items: [ self folders ];
		itemName: #displayString;
		matchSubstrings
]

{ #category : #accessing }
CuSpace >> foldersGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Folders';
		priority: 50;
		items: [ self folders ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuSpace >> lists [

	^ lists ifNil: [ lists := self application getListsFor: self ].
]

{ #category : #accessing }
CuSpace >> lists: anObject [
	lists := anObject
]

{ #category : #accessing }
CuSpace >> listsGtSearchFor: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Lists';
		priority: 200;
		items: [ self lists ];
		itemName: #displayString;
		matchSubstrings
]

{ #category : #accessing }
CuSpace >> listsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Lists';
		priority: 25;
		items: [ self lists ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuSpace >> reload [
  
	self application 
		getSpaceWithId: self id
		jsonDo: [ :json | self rawData: json ].
		
	self
		lists: nil;
		folders: nil
]

{ #category : #'CuObject - accessing' }
CuSpace >> url [

	^ self workspace url / 'v' / 's' / self id
]
