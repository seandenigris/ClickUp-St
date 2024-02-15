Extension { #name : #GtPhlowView }

{ #category : #'*ClickUp' }
GtPhlowView >> cuActionUpdateButtonReloading: aCuObject [

	self
		actionButtonIcon: BrGlamorousVectorIcons refresh
		tooltip: 'Update'
		action: [ :aButton :aTab | 
			aCuObject reload.
			aTab viewContentElement phlow update ]
]
