Class {
	#name : #CuCustomField,
	#superclass : #Object,
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#category : #ClickUp
}

{ #category : #accessing }
CuCustomField class >> fromDictionary: aDictionary [

	^ self new
		rawData: aDictionary;
		yourself
]

{ #category : #'as yet unclassified' }
CuCustomField >> dropdownOptionWithID: anInteger [ 
	
	self 
		rawDataAt: 'type_config'
		reader: [ :config |
			config 
				at: 'options'
				ifPresent: [ :options |
					options 
						detect: [ :dict | (dict at: 'orderindex') = anInteger ]
						ifFound: [ :dict | ^ dict ] ] ]
]

{ #category : #accessing }
CuCustomField >> fieldValue [

	^ self 
		rawDataAt: 'value'
		reader: [ :rawValue |
			self type = 'drop_down' 
				ifFalse: [ rawValue ]
				ifTrue: [ (self dropdownOptionWithID: rawValue) at: 'name' ] ]
]

{ #category : #accessing }
CuCustomField >> name [

	^ self rawDataAt: 'name'
]

{ #category : #accessing }
CuCustomField >> type [

	^ self rawDataAt: 'type'
]
