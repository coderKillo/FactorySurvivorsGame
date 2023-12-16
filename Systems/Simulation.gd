extends Node

var _tracker = EntityTracker.new()

@onready var _entity_placer = $GameWorld/EntityPlacer
@onready var _player = $GameWorld/Player
@onready var _ground = $GameWorld/GroundMap


func _ready():
	_entity_placer.setup(_tracker, _ground, _player)
