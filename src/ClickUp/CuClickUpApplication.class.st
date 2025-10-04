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

{ #category : #API }
CuClickUpApplication >> attach: anRlResource to: aCuTask [

	"API Reference: https://clickup.com/api/clickupreference/operation/CreateTaskAttachment/"
	| aUrl |
	aUrl := self baseUrl / 'task' / aCuTask id / 'attachment'.
	
	^ self
		postFile: anRlResource 
		to: aUrl
		do: [ :jsonResponse | jsonResponse ]
]

{ #category : #'as yet unclassified' }
CuClickUpApplication >> baseUrl [

	^ 'https://api.clickup.com/api/v2' asUrl
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

{ #category : #requesting }
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

{ #category : #requesting }
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

{ #category : #requesting }
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

{ #category : #API }
CuClickUpApplication >> createTaskInList: aCuList fromPpProject: aPpValue [

	"API Reference: https://clickup.com/api/clickupreference/operation/CreateTask/"
	| aUrl jsonDict jsonInput |
	aUrl := self baseUrl / 'list' / aCuList id / 'task'.
	jsonDict := Dictionary new
		at: 'name' put: aPpValue title;
		yourself.
		
	aPpValue hasLepiterPage ifTrue: [
		jsonDict 
			at: 'markdown_description' 
			put: aPpValue ensureLepiterPage asMarkdownPage withUnixLineEndings ].
			
	jsonInput := STONJSON toStringPretty: jsonDict.
	
	^ self
		postJson: jsonInput 
		to: aUrl
		do: [ :jsonResponse |
			| result |
			result := CuTask 
				fromDictionary: jsonResponse 
				withParent: aCuList
				inApplication: self.
				
			aPpValue supportMaterials 
				reject: [ :e | e isKindOf: RlEmail ]
				thenDo: [ :e | result attachmentsAdd: e ] ]
]

{ #category : #API }
CuClickUpApplication >> getCommentsForTaskWithId: aString jsonDo: aBlock [

	"Reference: https://developer.clickup.com/reference/gettaskcomments"
	| url |
	url := self baseUrl / 'task' / aString / 'comment'.
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #API }
CuClickUpApplication >> getFolderWithId: aString jsonDo: aBlock [

	"API Reference: https://clickup.com/api/clickupreference/operation/GetFolder/"
	| url |
	url := self baseUrl / 'folder' / aString.
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #requesting }
CuClickUpApplication >> getJsonAt: aUrl do: aBlock [

	^ self
		clientHTTP: #get 
		jsonAt: aUrl 
		do: aBlock
]

{ #category : #API }
CuClickUpApplication >> getListWithId: aString jsonDo: aBlock [

	"API Reference: https://clickup.com/api/clickupreference/operation/GetList/"
	| url |
	url := self baseUrl / 'list' / aString.
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #API }
CuClickUpApplication >> getListsFor: aCuObject [

	"API Reference: https://clickup.com/api/clickupreference/operation/GetLists/"
	^ self
		getJsonAt: aCuObject baseApiUrl / aCuObject id / 'list'
		do: [ :json |
			(json at: 'lists') collect: [ :dict |
				CuList 
					fromDictionary: dict 
					withParent: self
					inApplication: self ] ]
]

{ #category : #API }
CuClickUpApplication >> getSharedHierarchyForTeamWithId: aString jsonDo: aBlock [

	"API Reference: https://clickup.com/api/clickupreference/operation/SharedHierarchy/"
	| url |
	url := self baseUrl / 'team' / aString / 'shared'.
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #API }
CuClickUpApplication >> getSpaceWithId: aString jsonDo: aBlock [

	"API Reference: https://clickup.com/api/clickupreference/operation/GetSpace/"
	| url |
	url := self baseUrl / 'space' / aString.
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #API }
CuClickUpApplication >> getTaskWithId: aString jsonDo: aBlock [

	"Reference: https://clickup.com/api/clickupreference/operation/GetTask/"
	| url |
	url := self baseUrl / 'task' / aString ? ('include_subtasks' -> true).
	^ self
		getJsonAt: url
		do: aBlock
]

{ #category : #accessing }
CuClickUpApplication >> listWithId: aString [ 
	
	^ self workspaces do: [ :ws |
		(ws listWithId: aString)
			ifNotNil: [ :aList | ^ aList ] ]
]

{ #category : #requesting }
CuClickUpApplication >> postFile: anRlResourceable to: aUrl do: aBlock [

	[ 
		self client
			addPart: (ZnMimePart fieldName: 'attachment' fileNamed: anRlResourceable asRlResource file fullName).
			
		^ self
			clientHTTP: #post
			jsonAt: aUrl
			do: aBlock
	]
			ensure: [ self client resetEntity ]
]

{ #category : #requesting }
CuClickUpApplication >> postJson: aString to: aUrl do: aBlock [

	[ 
		self client
			contents: aString;
			contentType: ZnMimeType applicationJson.
			
		^ self
			clientHTTP: #post
			jsonAt: aUrl
			do: aBlock
	]
			ensure: [ self client resetEntity ]
]

{ #category : #utility }
CuClickUpApplication >> reload [

	self 
		getJsonAt: 'https://api.clickup.com/api/v2/team' 
		do: [ :json |
			^ workspaces := (json at: 'teams') collect: [ :dict |
				CuWorkspace 
					fromDictionary: dict
					withParent: nil
					inApplication: self ] ]
]

{ #category : #utility }
CuClickUpApplication >> reset [

	self workspaces: nil.
	self client: nil
]

{ #category : #accessing }
CuClickUpApplication >> spaceWithId: aString [ 
	
	^ self workspaces do: [ :ws |
		ws spaces
			detect: [ :s | s id = aString ]
			ifFound: [ :s | ^ s ] ]
]

{ #category : #accessing }
CuClickUpApplication >> taskWithId: aString [

	"Check cache"
	self allTasks detect: [ :task | task id = aString ] ifFound: [ :task | ^ task ].	
	
	"Attempt to load"	
	^ self
		getTaskWithId: aString
		jsonDo: [ :jsonDictionary | 
			| list |
			list := CuTask listFromJSON: jsonDictionary inApplication: self.
			list taskFromJson: jsonDictionary. ]
]

{ #category : #accessing }
CuClickUpApplication >> workspaces [

	^ workspaces ifNil: [ self reload. workspaces ].
]

{ #category : #accessing }
CuClickUpApplication >> workspaces: aCollection [

	workspaces := aCollection
]

{ #category : #'GT Views' }
CuClickUpApplication >> workspacesGtViewFor: aView [
	<gtView>
	^ aView list
		title: 'Workspaces';
		items: [ self workspaces ];
		itemText: #displayString;
		cuActionUpdateButtonReloading: self
]
