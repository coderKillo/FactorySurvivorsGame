extends Node

@export var simulation_speed = 1.0 / 10.0

var _tracker := EntityTracker.new()
@warning_ignore("unused_variable")
@warning_ignore("unused_private_class_variable")
var _power_system := PowerSystem.new()
var _upgrade_system := UpgradeSystem.new()

@onready var _entity_placer = $GameWorld/EntityPlacer
@onready var _enemy_placer = $GameWorld/EnemyPlacer
@onready var _player = $GameWorld/Player
@onready var _world_generator: WorldGenerator = $GameWorld/WorldGenerator
@onready var _pipe_system: PipeSystem = $GameWorld/PipeSystem
@onready var _gui: GUI = $CanvasLayer/GUI
@onready var _build_mode_manager: BuildModeManager = $BuildModeManager


func _ready():
	var planet_data = PlanetData.current_planet()
	_set_world_color(planet_data.color)

	var simulation_timer = $SimulationTimer

	_entity_placer.setup(_gui, _tracker, _player)
	_enemy_placer.setup(_player)
	_world_generator.setup(_player)
	_pipe_system.setup(_tracker)
	_upgrade_system.setup(_player, _tracker, _gui)
	_build_mode_manager.setup(_player, _gui, _enemy_placer, _tracker, simulation_timer)
	simulation_timer.start(simulation_speed)
	simulation_timer.timeout.connect(_on_SimulationTimer_timeout)
	Events.player_died.connect(_on_player_death)


func _on_SimulationTimer_timeout() -> void:
	Events.system_tick.emit(simulation_speed)
	_tracker.remove_queued_entity()


func _set_world_color(color_name: String) -> void:
	_world_generator.material.set_shader_parameter(
		"palette", RecolorTable._get_color_platte_from(color_name)
	)


func _on_player_death() -> void:
	var current_resources = PlanetData.current_planet().resources
	var new_resource = current_resources - _power_system.total_power()
	PlanetData.current_planet().resources = max(new_resource, 0)
