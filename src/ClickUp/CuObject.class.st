Class {
	#name : #CuObject,
	#superclass : #Object,
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#instVars : [
		'application',
		'parent'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuObject class >> fromDictionary: aDictionary withParent: aCuObject inApplication: anApplication [

	^ self new
		rawData: aDictionary;
		parent: aCuObject;
		application: anApplication;
		yourself
]

{ #category : #accessing }
CuObject class >> idFromJSON: aDictionary [

	^ aDictionary at: 'id'
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

	^ self class idFromJSON: self rawData
]

{ #category : #accessing }
CuObject >> name [

	^ self rawDataAt: 'name'
]

{ #category : #accessing }
CuObject >> parent [
	^ parent
]

{ #category : #accessing }
CuObject >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
CuObject >> printOn: aStream [

	self printFromDisplayStringOn: aStream
]

{ #category : #accessing }
CuObject >> rawDataGtViewFor: aView context: aContext [
	<gtView>
	
	^ self 
		rawDataGtViewFor: aView 
		context: aContext 
		do: [ :resultView | resultView cuActionUpdateButtonReloading: self ]
]

{ #category : #accessing }
CuObject >> tasksGtSearchFor: aSearch [
	<gtSearch>
	^ aSearch explicit
		title: 'Tasks (all)';
		priority: 2;
		search: [ :context |
			self allTasks select: [ :task |
				task matchesSearchQuery: context searchQuery trimBoth ]
		"matchSubstrings" ];
		itemName: #displayString
]

{ #category : #accessing }
CuObject >> timestampFromString: aString [
	^ (DateAndTime fromUnixTime: aString asInteger / 1000.0) translateToUTC
]

{ #category : #accessing }
CuObject >> url [

	^ self subclassResponsibility
]

{ #category : #accessing }
CuObject >> workspace [

	^ self parent workspace
]
