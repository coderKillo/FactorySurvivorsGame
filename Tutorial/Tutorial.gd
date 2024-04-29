class_name Tutorial
extends Node2D

@export var simulation_speed = 1.0 / 10.0

var _tracker := EntityTracker.new()
@warning_ignore("unused_variable")
@warning_ignore("unused_private_class_variable")
var _power_system := PowerSystem.new()
@warning_ignore("unused_variable")
@warning_ignore("unused_private_class_variable")
var _mining_system := MiningSystem.new()

@onready var _entity_placer = $GameWorld/EntityPlacer
@onready var _player = $GameWorld/Player
@onready var _enemy_spawner = $GameWorld/TutorialEntitySpawner
@onready var _entity_watcher = $GameWorld/TutorialEntityWatcher
@onready var _gui: GUI = $CanvasLayer/GUI
@onready var _tutorial_gui: TutorialGUI = $CanvasLayer/TutorialGUI
@onready var _tutorial_stages: TutorialStages = $TutorialStages


func _ready():
	_entity_placer.setup(_gui, _tracker, _player)
	_tutorial_stages.setup(_tutorial_gui, _player)
	_entity_watcher.setup(_tutorial_stages)
	_enemy_spawner.setup_spawner(_player, _tutorial_stages)

	$SimulationTimer.start(simulation_speed)
	$SimulationTimer.timeout.connect(_on_SimulationTimer_timeout)


func _on_SimulationTimer_timeout() -> void:
	Events.system_tick.emit(simulation_speed)
