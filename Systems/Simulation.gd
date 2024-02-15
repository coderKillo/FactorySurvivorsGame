extends Node

@export var simulation_speed = 1.0 / 10.0

var _tracker = EntityTracker.new()
@warning_ignore("unused_variable")
@warning_ignore("unused_private_class_variable")
var _power_system = PowerSystem.new()
@warning_ignore("unused_variable")
@warning_ignore("unused_private_class_variable")
var _mining_system = MiningSystem.new()

@onready var _entity_placer = $GameWorld/EntityPlacer
@onready var _enemy_placer = $GameWorld/EnemyPlacer
@onready var _player = $GameWorld/Player
@onready var _world_generator: WorldGenerator = $GameWorld/WorldGenerator
@onready var _gui = $CanvasLayer/GUI


func _ready():
	_entity_placer.setup(_gui, _tracker, _player)
	_enemy_placer.setup(_player)
	_world_generator.setup(_player)
	$SimulationTimer.start(simulation_speed)
	$SimulationTimer.timeout.connect(_on_SimulationTimer_timeout)


func _on_SimulationTimer_timeout() -> void:
	Events.system_tick.emit(simulation_speed)
	_tracker.remove_queued_entity()
