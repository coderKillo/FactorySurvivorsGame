extends Node2D

var Ore = preload("res://Entities/Mining/Ore.tscn")


func _ready():
	Events.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(enemy: Enemy):
	var ore = Ore.instantiate()
	ore.position = enemy.position

	call_deferred("add_child", ore)
