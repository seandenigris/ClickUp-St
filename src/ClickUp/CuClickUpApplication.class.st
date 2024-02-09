"
# API Documentation
- [Getting started](https://help.clickup.com/hc/en-us/articles/6303426241687-Getting-Started-with-the-ClickUp-API#api-docs)
- [API Docs](https://clickup.com/api/)
"
Class {
	#name : #CuClickUpApplication,
	#superclass : #Object,
	#instVars : [
		'apiToken',
		'client',
		'workspaces'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #ClickUp
}

{ #category : #accessing }
CuClickUpApplication class >> configureFromSTONFile: aFileReference [

	| dict |
	dict := STON fromStringWithComments: aFileReference contents.
	self uniqueInstance apiToken: (dict at: 'apiToken')
]

{ #category : #accessing }
CuClickUpApplication class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
CuClickUpApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : #accessing }
CuClickUpApplication >> allTasks [
	
	^ self workspaces flatCollect: [ :ws | ws allTasks ]
]

{ #category : #accessing }
CuClickUpApplication >> apiToken [
	^ apiToken
]

{ #category : #accessing }
CuClickUpApplication >> apiToken: anObject [
	apiToken := anObject
]

{ #category : #accessing }
CuClickUpApplication >> client [
	^ client ifNil: [ client := ZnClient new ]
]

{ #category : #accessing }
CuClickUpApplication >> client: anObject [
	client := anObject
]

{ #category : #accessing }
CuClickUpApplication >> clientDownload: aUrl to: aFileReference [
		
	self client
		url: aUrl;
		contentReader: nil;
		downloadTo: aFileReference;
		streaming: false
]

{ #category : #accessing }
CuClickUpApplication >> clientHTTP: aSelector jsonAt: aUrl do: aBlock [

	^ self
		clientHTTP: aSelector
		url: aUrl
		contentReader: [ :response |
			| json |
			json := STONJSON fromString: response contents.
			aBlock value: json ]
		ifFail: [ :err |
			| json |
			json := STONJSON fromString: err response contents.
			json 
				at: 'err'
				ifPresent: [ :errMsg | 
					"| errMsg |
					errMsg := err at: 'message'."
					self error: errMsg ] ].
]

{ #category : #accessing }
CuClickUpApplication >> clientHTTP: aSelector url: aUrl contentReader: readerBlock [

	
	"[" self client 
			contentReader: readerBlock;
			url: aUrl.
		self client request setAuthorization: self apiToken.
		^ self client perform: aSelector
	"]
		on: ZnHttpUnsuccessful
		do: errorBlock"
]

{ #category : #accessing }
CuClickUpApplication >> clientHTTP: aSelector url: aUrl contentReader: readerBlock ifFail: errorBlock [

	
	^ [ self client 
			contentReader: readerBlock;
			url: aUrl.
		self client request setAuthorization: self apiToken.
		self client perform: aSelector
	]
		on: ZnHttpUnsuccessful
		do: errorBlock
]

{ #category : #accessing }
CuClickUpApplication >> getJsonAt: aUrl do: aBlock [

	^ self
		clientHTTP: #get 
		jsonAt: aUrl 
		do: aBlock
]

{ #category : #accessing }
CuClickUpApplication >> reset [

	self workspaces: nil.
	self client: nil
]

{ #category : #'as yet unclassified' }
CuClickUpApplication >> spaceWithId: aString [ 
	
	^ self workspaces do: [ :ws |
		ws spaces
			detect: [ :s | s id = aString ]
			ifFound: [ :s | ^ s ] ]
]

{ #category : #accessing }
CuClickUpApplication >> workspaces [

	workspaces ifNotNil: [ ^ workspaces ].
	
	self 
		getJsonAt: 'https://api.clickup.com/api/v2/team' 
		do: [ :json |
			^ workspaces := (json at: 'teams') collect: [ :dict |
				CuWorkspace 
					fromDictionary: dict
					withParent: nil
					inApplication: self ] ]
]

{ #category : #accessing }
CuClickUpApplication >> workspaces: aCollection [

	workspaces := aCollection
]

{ #category : #accessing }
CuClickUpApplication >> workspacesGtViewFor: aView [
	<gtView>
	
	^ aView list
		title: 'Workspaces';
		items: [ self workspaces ];
		itemText: #displayString;
		yourself
]
