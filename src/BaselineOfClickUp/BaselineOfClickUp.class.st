Class {
	#name : #BaselineOfClickUp,
	#superclass : #BaselineOf,
	#category : #BaselineOfClickUp
}

{ #category : #baseline }
BaselineOfClickUp >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec 
				baseline: #'PharoEnhancements' with: [
					spec repository: 'github://seandenigris/Pharo-Enhancements' ];
				baseline: #'TheProjectProject' with: [
					spec repository: 'github://seandenigris/The-Project-Project' ].
				
			spec 
				package: #'ClickUp'
				with: [ spec requires: #(#'PharoEnhancements' #'TheProjectProject') ] ]
]
