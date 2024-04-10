Class {
	#name : #CuAttachment,
	#superclass : #CuObject,
	#traits : 'MATPropertyOwner + LlTCacheable',
	#classTraits : 'MATPropertyOwner classTrait + LlTCacheable classTrait',
	#category : #ClickUp
}

{ #category : #accessing }
CuAttachment >> contentsGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Contents';
		priority: 50;
		object: [ self cached ];
		view: #contentsGtViewFor:;
		inspectButtonFor: [ self cached ]
]

{ #category : #accessing }
CuAttachment >> download [

	| tmpfile |
	tmpfile := Tempfile named: self filename.
	self application 
		clientDownload: self url
		to: tmpfile reference.
	^ tmpfile
]

{ #category : #'as yet unclassified' }
CuAttachment >> extension [
	^ self rawDataAt: 'extension'
]

{ #category : #accessing }
CuAttachment >> filename [
	^ self url file
]

{ #category : #accessing }
CuAttachment >> name [

	^ self title
]

{ #category : #accessing }
CuAttachment >> open [
	self cached open
]

{ #category : #accessing }
CuAttachment >> openDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #open;
		yourself
]

{ #category : #accessing }
CuAttachment >> preview [
	self cached preview
]

{ #category : #accessing }
CuAttachment >> previewDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #preview;
		yourself
]

{ #category : #accessing }
CuAttachment >> previewGtViewFor: aView [
	"<gtView>"
	
	^ aView forward
		title: 'Preview';
		priority: 25;
		object: [ self cached ];
		view: #previewGtViewFor:;
		inspectButtonFor: [ self cached ]
]

{ #category : #accessing }
CuAttachment >> title [

	^ self rawDataAt: 'title'
]

{ #category : #accessing }
CuAttachment >> url [
	^ self 
		rawDataAt: 'url'
		reader: #asUrl
]
