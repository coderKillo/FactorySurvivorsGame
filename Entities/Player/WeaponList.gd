extends Node2D

@onready var _cooldown_timer: Timer = $Cooldown


func _ready():
	for node in get_children():
		if node is Weapon:
			node.setup(_cooldown_timer)
