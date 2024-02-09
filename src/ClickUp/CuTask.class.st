Class {
	#name : #CuTask,
	#superclass : #CuObject,
	#instVars : [
		'spaces',
		'attachments'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuTask class >> urlForId: aString [

	^ 'https://app.clickup.com/t' asUrl / aString
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
CuTask >> attachmnentsGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Attachments';
		items: [ self attachments ];
		itemText: #displayString;
		yourself
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
		items: [ self customFields ];
		column: 'Name'
			text: #name;
		column: 'Value'
			text: #fieldValue;
		yourself
]

{ #category : #accessing }
CuTask >> modificationTimestamp [

	^ self 
		rawDataAt: 'date_updated'
		reader: [ :str | DateAndTime fromUnixTime: str asInteger / 1000.0 ]
]

{ #category : #accessing }
CuTask >> reload [
  
	self application
		getJsonAt: 'https://api.clickup.com/api/v2/task' asUrl / self id
		do: [ :json | self rawData: json ]
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
