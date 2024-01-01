class_name Weapon
extends Node2D

@export var Projectile = preload("res://Systems/Weapon/Projectile.tscn")


func _process(_delta):
	look_at(get_global_mouse_position())


func fire():
	var projectile: Node2D = Projectile.instantiate()
	projectile.transform = global_transform
	projectile.top_level = true

	add_child(projectile)
	projectile.owner = owner
