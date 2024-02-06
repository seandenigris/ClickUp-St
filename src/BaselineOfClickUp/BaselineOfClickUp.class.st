Class {
	#name : #BaselineOfClickUp,
	#superclass : #BaselineOf,
	#category : #BaselineOfClickUp
}

{ #category : #baseline }
BaselineOfClickUp >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'ClickUp'
		]
]
