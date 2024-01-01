class_name EnemyPlacer
extends Node2D

@export var spawn_time = 1  # sek
@export var spawn_distance = 10

var _player: Node2D = null

@onready var _spawn_timer: Timer = $SpawnTimer
@onready var _enemies = {"Cyclops": preload("res://Entities/Enemies/Cyclops.tscn")}


func _ready():
	randomize()
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func setup(player: Node2D):
	_player = player
	_start()


func _start() -> void:
	_spawn_timer.start(spawn_time)


func _on_spawn_timer_timeout():
	_spawn_enemy()


func _spawn_enemy():
	if _player == null:
		return

	var angle = randi() % 360
	var spawn_pos = _player.position + (Vector2.from_angle(deg_to_rad(angle)) * spawn_distance)

	var enemy: Enemy = _enemies.Cyclops.instantiate()
	enemy.position = spawn_pos
	enemy.target = _player

	add_child(enemy)
