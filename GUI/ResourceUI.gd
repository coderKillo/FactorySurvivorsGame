class_name ResourceUI
extends MarginContainer

@export var resources: CollectedResources = preload("res://Entities/Player/Resources.tres")
@export var ResourceItemScene: PackedScene = preload("res://GUI/resource_item.tscn")

@onready var _resource_container = $PanelContainer/MarginContainer/VBoxContainer

var _resource_items: Dictionary
var _gui: GUI


func _ready():
	resources.collection_changed.connect(_on_resource_collection_changed)


func setup(gui: GUI):
	_gui = gui
	_gui.open_entity_ui_changed.connect(_on_open_entity_ui_changed)


func _on_resource_collection_changed(collection: Dictionary):
	show()

	for key in collection.keys():
		var blueprint := collection[key] as BlueprintEntity
		if key not in _resource_items:
			var resource_item: ResourceItem = ResourceItemScene.instantiate()

			_resource_container.add_child(resource_item)
			_resource_items[key] = resource_item

			var sprite: Sprite2D = blueprint.get_node_or_null("Sprite2D")
			if sprite != null:
				resource_item.sprite.texture = sprite.texture
				resource_item.sprite.modulate = sprite.modulate
				resource_item.sprite.region_enabled = sprite.region_enabled
				resource_item.sprite.region_rect = sprite.region_rect

			resource_item.button.pressed.connect(_on_item_pressed.bind(key))

		_resource_items[key].label.text = "x" + str(blueprint.stack_count)


func _on_open_entity_ui_changed(value):
	if value != null:
		for key in _resource_items.keys():
			_on_item_pressed(key)


func _on_item_pressed(item_name: String):
	if _gui.open_entity_ui == null:
		return

	for panel in _gui.open_entity_ui.panels:
		if item_name in panel.item_filter:
			for _i in range(resources.collection[item_name].stack_count):
				_gui.open_entity_ui._add_blueprint_to_panel(item_name, panel)
				resources.remove_item(item_name)
