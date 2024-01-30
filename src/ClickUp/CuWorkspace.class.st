Class {
	#name : #CuWorkspace,
	#superclass : #CuObject,
	#category : #ClickUp
}

{ #category : #accessing }
CuWorkspace class >> all [
	| jsonString json |
	jsonString := self get: 'https://api.clickup.com/api/v2/team'.
	json := STONJSON fromString: jsonString.
	^ (json at: 'teams') collect: [ :dict |
		self fromDictionary: dict ]
]

{ #category : #accessing }
CuWorkspace >> id [

	^ self rawData at: 'id'
]

{ #category : #accessing }
CuWorkspace >> spaces [

	| jsonString json |
	jsonString := self class get: 'https://api.clickup.com/api/v2/team/', self id, '/space'.
	json := STONJSON fromString: jsonString.
	^ (json at: 'spaces') collect: [ :dict |
		CuSpace fromDictionary: dict ]
]
