extends Node

@export var simulation_speed = 1.0 / 30.0

var _tracker = EntityTracker.new()
var _power_system = PowerSystem.new()
var _mining_system = MiningSystem.new()

@onready var _entity_placer = $GameWorld/EntityPlacer
@onready var _enemy_placer = $GameWorld/EnemyPlacer
@onready var _player = $GameWorld/Player
@onready var _ground = $GameWorld/GroundMap


func _ready():
	_entity_placer.setup(_tracker, _ground, _player)
	_enemy_placer.setup(_player)
	$SimulationTimer.start(simulation_speed)
	$SimulationTimer.timeout.connect(_on_SimulationTimer_timeout)


func _on_SimulationTimer_timeout() -> void:
	Events.system_tick.emit(simulation_speed)
