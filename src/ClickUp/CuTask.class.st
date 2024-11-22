Class {
	#name : #CuTask,
	#superclass : #CuObject,
	#instVars : [
		'attachments',
		'subtasks'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuTask class >> urlForId: aString [

	^ 'https://app.clickup.com/t' asUrl / aString
]

{ #category : #'as yet unclassified' }
CuTask >> asPpProject [

	^ (PpProject titled: self name)
		clickUpTaskId: self id;
		yourself
]

{ #category : #accessing }
CuTask >> at: keyString [

	self rawData 
		at: keyString
		ifPresent: [ :val | ^ val ].
		
	^ self customFields
		detect: [ :field | field name = keyString ]
		ifFound: #fieldValue
		ifNone: [ self error: 'Unknown field' ]
]

{ #category : #accessing }
CuTask >> attachments [

	attachments ifNotNil: [ ^ attachments ].
	
	^ attachments := self
		rawDataAt: 'attachments'
		reader: [ :col | 
			col collect: [ :dict | 
				CuAttachment
					fromDictionary: dict
					withParent: self
					inApplication: self application ] ]
		ifAbsent: [ #() ]
]

{ #category : #accessing }
CuTask >> attachments: anObject [
	attachments := anObject
]

{ #category : #'as yet unclassified' }
CuTask >> attachmentsAdd: anRlResource [

	self application
		attachment: anRlResource 
		to: self.
		
	^ anRlResource
]

{ #category : #accessing }
CuTask >> attachmnentsGtViewFor: aView [
	<gtView>
	^ aView list
		title: 'Attachments';
		priority: 60;
		items: [ self attachments ];
		itemText: #displayString;
		inspectButtonFor: [ self attachments ];
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuTask >> creationTimestamp [

	^ self 
		rawDataAt: 'date_created'
		reader: [ :str | DateAndTime fromUnixTime: str asInteger / 1000.0 ]
]

{ #category : #accessing }
CuTask >> creator [
	^ self at: 'creator'
]

{ #category : #accessing }
CuTask >> customFields [

	^ self rawData 
		at: 'custom_fields'
		ifPresent: [ :col |
			col collect: [ :dict |
				CuCustomField fromDictionary: dict ] ]
]

{ #category : #accessing }
CuTask >> customFieldsGtViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Custom Fields';
		priority: 20;
		items: [ self customFields ];
		column: 'Name' text: #name;
		column: 'Value' text: #fieldValue;
		cuActionUpdateButtonReloading: self
]

{ #category : #'as yet unclassified' }
CuTask >> description [

	^ self rawDataAt: #description
]

{ #category : #accessing }
CuTask >> descriptionGtViewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		priority: 25;
		text: [ self description ];
		cuActionUpdateButtonReloading: self
]

{ #category : #'as yet unclassified' }
CuTask >> matchesSearchQuery: aString [

	(self name includesSubstring: aString caseSensitive: false) ifTrue: [ ^ true ].
	
	(self description includesSubstring: aString caseSensitive: false) ifTrue: [ ^ true ].
	
	self customFields anySatisfy: [ :field | field matchesSearchQuery: aString ].
	
	^ false
]

{ #category : #accessing }
CuTask >> modificationTimestamp [

	^ self 
		rawDataAt: 'date_updated'
		reader: [ :str | (DateAndTime fromUnixTime: str asInteger / 1000.0) translateToUTC ]
]

{ #category : #'as yet unclassified' }
CuTask >> ppProject [

	^ self ppProjectList 
		detect: [ :proj | proj clickUpTaskId = self id ] 
		ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
CuTask >> ppProjectEnsure [

	^ self ppProjectExists
		ifTrue: [ self ppProject ]
		ifFalse: [ self asPpProject import ]
]

{ #category : #'as yet unclassified' }
CuTask >> ppProjectExists [

	^ self ppProject isNotNil
]

{ #category : #'as yet unclassified' }
CuTask >> ppProjectGtActionFor: anAction [
	<gtAction>

	| iconStencil |
	iconStencil := [
		| elpIcon |
		elpIcon := BrGlamorousVectorIcons branching create.
		self ppProjectExists ifFalse: [ elpIcon background: Color veryLightGray ].
		elpIcon ] asStencil.
	
	^ anAction button
		icon: iconStencil;
		action: [ :button | button phlow spawnObject: 
			self ppProjectEnsure ]
]

{ #category : #'as yet unclassified' }
CuTask >> ppProjectList [

	^ PpProjectList uniqueInstance
]

{ #category : #accessing }
CuTask >> presentOnWeb [

	^ self url open
]

{ #category : #accessing }
CuTask >> presentOnWebDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #presentOnWeb;
		gtIcon: BrGlamorousVectorIcons link;
		isLabelVisible: false;
		yourself
]

{ #category : #accessing }
CuTask >> reload [

	self application 
		getTaskWithId: self id
		jsonDo: [ :json | self rawData: json ].
		
	self
		attachments: nil;
		subtasks: nil
]

{ #category : #accessing }
CuTask >> reloadDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #reload;
		gtIcon: BrGlamorousVectorIcons refresh;
		isLabelVisible: false;
		yourself
]

{ #category : #accessing }
CuTask >> subtasks [

	subtasks ifNotNil: [ ^ subtasks ].
	
	^ self rawData 
		at: 'subtasks'
		ifPresent: [ :col |
			subtasks := col collect: [ :dict |
				"A subtask is actually a task, but only part of its data is included along with its parent"
				CuSubtask 
					fromId: (dict at: 'id')
					withParent: self
					inApplication: self application ] ]
		ifAbsent: [ #() ]
]

{ #category : #accessing }
CuTask >> subtasks: anObject [
	subtasks := anObject
]

{ #category : #accessing }
CuTask >> subtasksGtViewFor: aView [
	<gtView>
	^ aView list
		title: 'Subtasks';
		priority: 40;
		items: [ self subtasks ];
		itemText: #displayString;
		inspectButtonFor: [ self subtasks ];
		cuActionUpdateButtonReloading: self
]

{ #category : #accessing }
CuTask >> timeSpent [

	^ self
		rawDataAt: 'time_spent'
		reader: [ :str | str asInteger milliSeconds ]
]

{ #category : #accessing }
CuTask >> url [

	^ self class urlForId: self id
]
