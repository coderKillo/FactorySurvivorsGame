class_name CollectedResources
extends Resource

@export var ore_amount := 0:
	set(value):
		ore_amount = value
		changed.emit()

@export var ore_limit := 100:
	set(value):
		ore_limit = value
		changed.emit()

@export var molt_amount := 0:
	set(value):
		molt_amount = value
		changed.emit()

@export var molt_limit := 100:
	set(value):
		molt_limit = value
		changed.emit()
