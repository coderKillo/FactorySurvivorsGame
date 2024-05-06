class_name TutorialEntityWatcher
extends Node2D

var _tutorial_stages: TutorialStages


func _ready():
	Events.entity_placed.connect(_on_entity_placed)


func setup(tutorial_stages: TutorialStages) -> void:
	_tutorial_stages = tutorial_stages


func _on_entity_placed(entity: Entity, _cellv: Vector2) -> void:
	if Library.get_entity_name(entity) == "Smelter":
		_tutorial_stages.tutorial_event.emit(TutorialStages.TutorialEvents.SMELTER_BUILDED)
		entity._ore_bucket.content_changed.connect(_on_smelter_ore_bucket_changed)

	if Library.get_entity_name(entity) == "PowerPlant":
		entity._molt_bucket.content_changed.connect(_on_power_plant_molt_bucked_changed)
		entity.data.amount = 1  # set required heat to 1 to give more power

	if Library.get_entity_name(entity) == "Turret":
		entity._power.received_power.connect(_on_turret_received_power)


func _on_smelter_ore_bucket_changed(bucket: Bucket):
	if not bucket.empty():
		_tutorial_stages.tutorial_event.emit(TutorialStages.TutorialEvents.SMELTER_LOADED)


func _on_power_plant_molt_bucked_changed(bucket: Bucket):
	if not bucket.empty():
		_tutorial_stages.tutorial_event.emit(TutorialStages.TutorialEvents.POWER_PLANT_LOADED)


func _on_turret_received_power(_amount, _delta):
	pass
