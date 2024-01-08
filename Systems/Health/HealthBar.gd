extends ProgressBar

@export var _health: Health


func _ready():
	_health.take_damage.connect(_on_take_damage)
	value = 1
	hide()


func _on_take_damage(_amount, points):
	if points <= _health.max_health:
		show()
	if points <= 0:
		hide()
		
	value = float(points) / _health.max_health
	
