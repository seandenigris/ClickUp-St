Extension { #name : #PpValue }

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskId [
	^ self maLazyPropertyUsing: self clickUpTaskIdDescription
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskId: aString [

	^ self
		propertyAt: #clickUpTaskId
		put: aString
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskIdDescription [
	<magritteDescription>
	
	^ MAStringDescription new
			accessor: #clickUpTaskId;
			label: 'ClickUp Task ID';
			priority: 850;
			yourself
]

{ #category : #'*ClickUp' }
PpValue >> clickUpTaskUrl [

	self clickUpTaskId ifNil: [ ^ nil ].

	^ 'https://app.clickup.com/t' asUrl / self clickUpTaskId
]
