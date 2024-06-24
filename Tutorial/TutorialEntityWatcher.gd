class_name TutorialEntityWatcher
extends Node2D

var _tutorial_stages: TutorialStages


func _ready():
	Events.entity_placed.connect(_on_entity_placed)
	Events.ground_entity_spawn.connect(_on_ground_entity_spawned)


func setup(tutorial_stages: TutorialStages) -> void:
	_tutorial_stages = tutorial_stages


func _on_entity_placed(entity: Entity, _cellv: Vector2) -> void:
	if Library.get_entity_name(entity) == "Smelter":
		entity._ore_bucket.content_changed.connect(_on_smelter_ore_bucket_changed)


func _on_smelter_ore_bucket_changed(bucket: Bucket):
	if not bucket.empty():
		_tutorial_stages.tutorial_event.emit(TutorialStages.TutorialEvents.SMELTER_LOADED)


func _on_ground_entity_spawned(entity_name: String, _pos: Vector2, _color: String) -> void:
	if entity_name == "Ore":
		_tutorial_stages.tutorial_event.emit(TutorialStages.TutorialEvents.ORE_EXTRACTED)
