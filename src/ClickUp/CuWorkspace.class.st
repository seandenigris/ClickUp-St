Class {
	#name : #CuWorkspace,
	#superclass : #CuObject,
	#instVars : [
		'spaces'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuWorkspace >> spaces [

	spaces ifNotNil: [ ^ spaces ].
	
	^ self application
		getJsonAt: 'https://api.clickup.com/api/v2/team/', self id, '/space' 
		do: [ :json |
			spaces := (json at: 'spaces') collect: [ :dict |
				CuSpace fromDictionary: dict forApplication: self application ] ]
]

{ #category : #accessing }
CuWorkspace >> spacesGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Spaces';
		items: [ self spaces ];
		itemText: #displayString;
		yourself
]
