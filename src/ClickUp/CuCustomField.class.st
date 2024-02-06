Class {
	#name : #CuCustomField,
	#superclass : #Object,
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#category : #ClickUp
}

{ #category : #accessing }
CuCustomField class >> fromDictionary: aDictionary [

	^ self new
		rawData: aDictionary;
		yourself
]

{ #category : #accessing }
CuCustomField >> fieldValue [

	^ self rawDataAt: 'value'
]

{ #category : #accessing }
CuCustomField >> name [

	^ self rawDataAt: 'name'
]
