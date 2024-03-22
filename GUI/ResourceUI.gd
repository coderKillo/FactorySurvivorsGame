class_name ResourceUI
extends MarginContainer

@export var resources: CollectedResources = preload("res://Entities/Player/Resources.tres")

@onready var _load_bar: TextureProgressBar = $HBoxContainer/LoadBar
@onready var _molten_bar: TextureProgressBar = $HBoxContainer/MoltenBar

var _gui: GUI


func _ready():
	resources.changed.connect(_on_resource_collection_changed)
	_on_resource_collection_changed()


func setup(gui: GUI):
	_gui = gui


func _on_resource_collection_changed():
	_load_bar.max_value = resources.ore_limit
	_load_bar.value = resources.ore_amount
	_molten_bar.max_value = resources.molt_limit
	_molten_bar.value = resources.molt_amount
