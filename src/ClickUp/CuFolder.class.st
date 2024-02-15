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
CuFolder >> lists [

	^ lists ifNil: [ lists := self application getListsFor: self ].
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

{ #category : #accessing }
CuFolder >> url [

	^ self workspace url / 'v' / 'f' / self id
]
