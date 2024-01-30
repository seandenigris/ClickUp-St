Class {
	#name : #CuObject,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#classVars : [
		'ApiToken',
		'Client'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuObject class >> apiToken [
	^ ApiToken
]

{ #category : #accessing }
CuObject class >> apiToken: anObject [
	ApiToken := anObject
]

{ #category : #accessing }
CuObject class >> client [
	^ Client ifNil: [ Client := ZnClient new ]
]

{ #category : #accessing }
CuObject class >> client: anObject [
	Client := anObject
]

{ #category : #'as yet unclassified' }
CuObject class >> fromDictionary: aDictionary [

	^ self new
		rawData: aDictionary;
		yourself
]

{ #category : #accessing }
CuObject class >> get: aUrl [
	
	self client url: aUrl.
	self client request setAuthorization: self apiToken.
	^ self client get.
]

{ #category : #accessing }
CuObject >> rawData [
	^ rawData
]

{ #category : #accessing }
CuObject >> rawData: anObject [
	rawData := anObject
]
