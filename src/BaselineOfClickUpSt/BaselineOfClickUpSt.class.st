Class {
	#name : #BaselineOfClickUpSt,
	#superclass : #BaselineOf,
	#category : #BaselineOfClickUpSt
}

{ #category : #baseline }
BaselineOfClickUpSt >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'ClickUp'
		]
]
