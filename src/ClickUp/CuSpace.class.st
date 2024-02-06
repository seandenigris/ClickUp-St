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

{ #category : #accessing }
CuSpace >> folders [

	folders ifNotNil: [ ^ folders ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/space' asUrl / self id / 'folder'
		do: [ :json |
			folders := (json at: 'folders') collect: [ :dict |
				CuFolder fromDictionary: dict forApplication: self application ] ]
]

{ #category : #accessing }
CuSpace >> foldersGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Folders';
		items: [ self folders ];
		itemText: #displayString;
		yourself
]

{ #category : #accessing }
CuSpace >> lists [

	lists ifNotNil: [ ^ lists ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/space' asUrl / self id / 'list'
		do: [ :json |
			lists := (json at: 'lists') collect: [ :dict |
				CuList fromDictionary: dict forApplication: self application ] ]
]

{ #category : #accessing }
CuSpace >> listsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Lists';
		items: [ self lists ];
		itemText: #displayString;
		yourself
]
