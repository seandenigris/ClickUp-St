Class {
	#name : #CuFolder,
	#superclass : #CuObject,
	#instVars : [
		'lists'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuFolder >> lists [

	lists ifNotNil: [ ^ lists ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/folder' asUrl / self id / 'list'
		do: [ :json |
			lists := (json at: 'lists') collect: [ :dict |
				CuList fromDictionary: dict forApplication: self application ] ]
]

{ #category : #accessing }
CuFolder >> listsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Lists';
		items: [ self lists ];
		itemText: #displayString;
		yourself
]
