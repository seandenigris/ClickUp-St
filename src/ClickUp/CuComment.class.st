Class {
	#name : #CuComment,
	#superclass : #CuObject,
	#category : #ClickUp
}

{ #category : #'as yet unclassified' }
CuComment >> author [

	^ self 
		rawDataAt: 'user'
		reader: [ :aDict | 
			CuUser fromDictionary: aDict ]
]

{ #category : #'as yet unclassified' }
CuComment >> authorDescription [
	<magritteDescription>

	^ MAToOneRelationDescription new
		accessor: #author;
		referenceDisplay: #displayString;
		propertyAt: #columnWeight put: 0.15;
		yourself
]

{ #category : #'as yet unclassified' }
CuComment >> displayStringOn: aStream [

	aStream
		nextPutAll: self text;
		space;
		display: self author;
		space;
		nextPutAll: self timestamp printUS
]

{ #category : #'as yet unclassified' }
CuComment >> text [

	^ self rawDataAt: 'comment_text'
]

{ #category : #'as yet unclassified' }
CuComment >> textDescription [
	<magritteDescription>

	^ MAStringDescription new
		accessor: #text;
		propertyAt: #columnWeight put: 0.65;
		yourself
]

{ #category : #'as yet unclassified' }
CuComment >> timestamp [

	^ self 
		rawDataAt: 'date'
		reader: [ :str | self timestampFromString: str ]
]

{ #category : #'as yet unclassified' }
CuComment >> timestampDescription [
	<magritteDescription>

	^ MAToOneRelationDescription new
		accessor: #timestamp;
		referenceDisplay: #printUS;
		propertyAt: #columnWeight put: 0.2;
		yourself
]
