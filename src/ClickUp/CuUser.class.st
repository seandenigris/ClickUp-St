Class {
	#name : #CuUser,
	#superclass : #CuObject,
	#category : #ClickUp
}

{ #category : #'as yet unclassified' }
CuUser >> email [

	^ self rawDataAt: 'email'
]

{ #category : #'as yet unclassified' }
CuUser >> name [

	^ self rawDataAt: 'username'
]
