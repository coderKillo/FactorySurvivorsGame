class_name Weapon
extends Node2D

@export var fire_rate = 0.3
@export var Projectile = preload("res://Systems/Weapon/Projectile.tscn")

var is_right = false

@onready var _cooldown_timer: Timer = $Cooldown
@onready var _shoot_position: Marker2D = $Marker2D

var _firing = false
var _on_cooldown = false


func _ready():
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)


func _process(_delta):
	var mouse = get_global_mouse_position()
	look_at(mouse)
	_set_weapon_direction(mouse)

	if _firing and not _on_cooldown:
		_fire_bullet()


func fire(pressed: bool):
	_firing = pressed


func _on_cooldown_timeout():
	_on_cooldown = false


func _set_weapon_direction(pos: Vector2):
	is_right = pos.x > global_position.x


func _fire_bullet():
	var projectile: Node2D = Projectile.instantiate()
	projectile.transform = _shoot_position.global_transform
	projectile.top_level = true

	add_child(projectile)
	projectile.owner = owner

	_on_cooldown = true
	_cooldown_timer.start(fire_rate)
