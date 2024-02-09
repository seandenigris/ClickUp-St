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
				baseline: 'LivingLibrary' with: [
					spec repository: 'github://seandenigris/Living-Library' ];
				baseline: 'PharoEnhancements' with: [
					spec repository: 'github://seandenigris/Pharo-Enhancements' ].
				
			spec 
				package: 'ClickUp'
				with: [ spec requires: #('LivingLibrary' 'PharoEnhancements') ] ]
]
