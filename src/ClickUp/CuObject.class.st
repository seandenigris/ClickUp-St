Class {
	#name : #CuObject,
	#superclass : #Object,
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#instVars : [
		'application'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuObject class >> fromDictionary: aDictionary forApplication: anApplication [

	^ self new
		rawData: aDictionary;
		application: anApplication;
		yourself
]

{ #category : #accessing }
CuObject >> application [
	^ application
]

{ #category : #accessing }
CuObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
CuObject >> displayStringOn: aStream [

	aStream
		nextPutAll: self name
]

{ #category : #accessing }
CuObject >> id [

	^ self rawDataAt: 'id'
]

{ #category : #accessing }
CuObject >> name [

	^ self rawDataAt: 'name'
]

{ #category : #accessing }
CuObject >> printOn: aStream [

	self printFromDisplayStringOn: aStream
]
