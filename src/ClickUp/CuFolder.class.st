Class {
	#name : #CuFolder,
	#superclass : #CuObject,
	#instVars : [
		'lists'
	],
	#category : #ClickUp
}

{ #category : #'as yet unclassified' }
CuFolder >> allTasks [
	
	^ self lists flatCollect: [ :list | list tasks ]
]

{ #category : #accessing }
CuFolder >> baseApiUrl [
	
	^ 'https://api.clickup.com/api/v2/folder' asUrl
]

{ #category : #accessing }
CuFolder >> lists [

	^ lists ifNil: [ lists := self application getListsFor: self ].
]

{ #category : #accessing }
CuFolder >> lists: anObject [
	lists := anObject
]

{ #category : #accessing }
CuFolder >> listsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Lists';
		items: [ self lists ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuFolder >> reload [
  
	self application 
		getFolderWithId: self id
		jsonDo: [ :json | self rawData: json ].
		
	self lists: nil
]

{ #category : #accessing }
CuFolder >> url [

	^ self workspace url / 'v' / 'f' / self id
]
