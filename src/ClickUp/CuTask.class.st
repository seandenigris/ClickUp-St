Class {
	#name : #CuTask,
	#superclass : #CuObject,
	#instVars : [
		'spaces'
	],
	#category : #ClickUp
}

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
